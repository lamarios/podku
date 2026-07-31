package com.github.lamarios.podku.podcasts;


import com.github.lamarios.podku.episodes.Episode;
import com.github.lamarios.podku.episodes.EpisodeFile;
import com.github.lamarios.podku.episodes.EpisodeFileType;
import com.github.lamarios.podku.episodes.EpisodePerson;
import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.podcasts.PodcastPerson;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.IOException;
import java.io.StringReader;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Parses podcast RSS/XML (with iTunes namespace extensions) into a Podcast.
 */
public class PodcastParser {

    private static final String ITUNES_NS = "http://www.itunes.com/dtds/podcast-1.0.dtd";

    public Podcast parseUrl(Podcast podcast) {
        HttpClient client = HttpClient.newHttpClient();
        try {
            HttpRequest request = HttpRequest.newBuilder(URI.create(podcast.getUrl()))
                    .GET()
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() != 200) {
                throw new PodcastFeedException(
                        "Failed to fetch feed at " + podcast.getUrl() + " (status " + response.statusCode() + ")");
            }
            return parse(podcast, response.body());
        } catch (IOException e) {
            throw new PodcastFeedException("Failed to fetch feed at " + podcast.getUrl() + ": " + e.getMessage());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new PodcastFeedException("Fetch interrupted for " + podcast.getUrl());
        }
    }

    /**
     * Parses a raw XML string (fetched from a feed's feedUrl).
     */
    public Podcast parse(Podcast podcast, String xmlString) {
        Document document = parseDocument(xmlString);
        Element channel = findFirstDescendant(document, "channel");
        if (channel == null) {
            throw new PodcastFeedException("No <channel> element found in feed");
        }

        List<Episode> episodes = new ArrayList<>();
        for (Element item : directChildren(channel, "item")) {
            Episode e = parseItem(podcast, item);
            if (podcast.getEpisodes() == null) {
                podcast.setEpisodes(new ArrayList<>());
            }
            if (podcast.getEpisodes().stream().noneMatch(episode -> episode.getGuid().equals(e.getGuid()))) {
                episodes.add(e);
            }
        }

        podcast.setName(orEmpty(text(channel, "title")));
        String description = text(channel, "description");
        podcast.setDescription(description != null ? description : itunesText(channel, "summary"));
        podcast.setArtworkUrl(channelImage(channel));
        podcast.setAuthor(itunesText(channel, "author"));
        podcast.setLink(text(channel, "link"));
        if (podcast.getEpisodes() == null) {
            podcast.setEpisodes(episodes);
        } else {
            podcast.getEpisodes().addAll(episodes);
        }

        List<PodcastPerson> podcastPeople = getPodcastPeople(podcast, channel);
        if (podcast.getPeople() == null) {
            podcast.setPeople(podcastPeople);
        } else {
            podcast.getPeople().clear();
            podcast.getPeople().addAll(podcastPeople);
        }

        return podcast;
    }

    private Document parseDocument(String xmlString) {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(false); // keep literal "itunes:xxx" / "podcast:xxx" tag names
            DocumentBuilder builder = factory.newDocumentBuilder();
            return builder.parse(new InputSource(new StringReader(xmlString)));
        } catch (Exception e) {
            throw new PodcastFeedException("Failed to parse feed XML: " + e.getMessage());
        }
    }

    private Episode parseItem(Podcast podcast, Element item) {
        Element enclosure = firstDirectChild(item, "enclosure");

        Episode episode = new Episode();
        episode.setTitle(text(item, "title") != null ? text(item, "title") : "Untitled episode");
        String description = text(item, "description");
        episode.setDescription(description != null ? description : itunesText(item, "summary"));
        episode.setAudioUrl(enclosure != null ? attr(enclosure, "url") : null);
        episode.setAudioType(enclosure != null ? attr(enclosure, "type") : null);
        episode.setAudioLengthBytes(parseLongOrNull(enclosure != null ? attr(enclosure, "length") : null));
        episode.setPubDateMillis(parseDateMillis(text(item, "pubDate")));
        episode.setDurationSeconds(parseDurationSeconds(itunesText(item, "duration")));
        episode.setGuid(text(item, "guid"));
        episode.setImageUrl(itemImage(item));
        episode.setSeasonNumber(parseIntOrNull(itunesText(item, "season")));
        episode.setEpisodeNumber(parseIntOrNull(itunesText(item, "episode")));
        episode.setEpisodeType(itunesText(item, "episodeType"));

        String explicitRaw = itunesText(item, "explicit");
        String explicitLower = explicitRaw != null ? explicitRaw.toLowerCase() : "false";
        episode.setExplicit(explicitLower.equals("true") || explicitLower.equals("yes"));

        episode.setLink(text(item, "link"));
        episode.setPodcast(podcast);

        episode.setPeople(getPeople(episode, item));
        episode.setFiles(getFiles(episode, item));

        return episode;
    }

    // --- helpers ------------------------------------------------------

    private List<EpisodePerson> getPeople(Episode episode, Element episodeRoot) {
        List<EpisodePerson> people = new ArrayList<>();
        for (Element e : directChildren(episodeRoot, "podcast:person")) {
            EpisodePerson person = new EpisodePerson();
            person.setName(e.getTextContent());
            person.setEpisode(episode);
            person.setRole(attr(e, "role"));
            person.setImage(attr(e, "img"));
            person.setLink(attr(e, "href"));
            person.setGroup(attr(e, "role"));
            people.add(person);
        }
        return people;
    }

    private List<PodcastPerson> getPodcastPeople(Podcast podcast, Element root) {
        List<PodcastPerson> people = new ArrayList<>();
        for (Element e : directChildren(root, "podcast:person")) {
            PodcastPerson person = new PodcastPerson();
            person.setName(e.getTextContent());
            person.setPodcast(podcast);
            person.setRole(attr(e, "role"));
            person.setImage(attr(e, "img"));
            person.setLink(attr(e, "href"));
            person.setGroup(attr(e, "role"));
            people.add(person);
        }
        return people;
    }

    private List<EpisodeFile> getFiles(Episode episode, Element episodeRoot) {
        List<EpisodeFile> files = new ArrayList<>();

        for (Element e : directChildren(episodeRoot, "podcast:transcript")) {
            EpisodeFile file = new EpisodeFile();
            file.setType(EpisodeFileType.transcript);
            file.setLanguage(attr(e, "language"));
            file.setRel(attr(e, "rel"));
            file.setMime(orEmpty(attr(e, "type")));
            file.setUrl(orEmpty(attr(e, "url")));
            file.setEpisode(episode);
            files.add(file);
        }

        for (Element e : directChildren(episodeRoot, "podcast:chapters")) {
            EpisodeFile file = new EpisodeFile();
            file.setType(EpisodeFileType.chapters);
            file.setUrl(orEmpty(attr(e, "url")));
            file.setMime(attr(e, "type"));
            file.setEpisode(episode);
            files.add(file);
        }

        return files;
    }

    private String text(Element parent, String tag) {
        Element el = firstDirectChild(parent, tag);
        return el != null ? el.getTextContent().trim() : null;
    }

    /**
     * Reads a tag from the itunes: namespace, e.g. &lt;itunes:duration&gt;.
     */
    private String itunesText(Element parent, String tag) {
        return text(parent, "itunes:" + tag);
    }

    private String channelImage(Element channel) {
        Element itunesImage = firstDirectChild(channel, "itunes:image");
        if (itunesImage != null) {
            String href = attr(itunesImage, "href");
            if (href != null) return href;
        }
        Element rssImage = firstDirectChild(channel, "image");
        if (rssImage != null) {
            return text(rssImage, "url");
        }
        return null;
    }

    private String itemImage(Element item) {
        Element itunesImage = firstDirectChild(item, "itunes:image");
        return itunesImage != null ? attr(itunesImage, "href") : null;
    }

    // --- low-level DOM helpers ------------------------------------------------------

    private Element findFirstDescendant(Document doc, String tagName) {
        NodeList list = doc.getElementsByTagName(tagName);
        return list.getLength() > 0 ? (Element) list.item(0) : null;
    }

    private List<Element> directChildren(Element parent, String tagName) {
        List<Element> result = new ArrayList<>();
        NodeList children = parent.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            Node node = children.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE && node.getNodeName().equals(tagName)) {
                result.add((Element) node);
            }
        }
        return result;
    }

    private Element firstDirectChild(Element parent, String tagName) {
        List<Element> children = directChildren(parent, tagName);
        return children.isEmpty() ? null : children.get(0);
    }

    private String attr(Element el, String name) {
        return el.hasAttribute(name) ? el.getAttribute(name) : null;
    }

    private String orEmpty(String s) {
        return s != null ? s : "";
    }

    private Long parseLongOrNull(String s) {
        if (s == null || s.isEmpty()) return null;
        try {
            return Long.parseLong(s);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer parseIntOrNull(String s) {
        if (s == null || s.isEmpty()) return null;
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    // --- date / duration parsing ------------------------------------------------------

    private static final Map<String, Integer> MONTHS_BY_ABBR = new HashMap<>();
    private static final Map<String, Integer> NAMED_TIMEZONE_OFFSET_MINUTES = new HashMap<>();
    private static final Pattern WHITESPACE = Pattern.compile("\\s+");

    static {
        MONTHS_BY_ABBR.put("jan", 1);
        MONTHS_BY_ABBR.put("feb", 2);
        MONTHS_BY_ABBR.put("mar", 3);
        MONTHS_BY_ABBR.put("apr", 4);
        MONTHS_BY_ABBR.put("may", 5);
        MONTHS_BY_ABBR.put("jun", 6);
        MONTHS_BY_ABBR.put("jul", 7);
        MONTHS_BY_ABBR.put("aug", 8);
        MONTHS_BY_ABBR.put("sep", 9);
        MONTHS_BY_ABBR.put("oct", 10);
        MONTHS_BY_ABBR.put("nov", 11);
        MONTHS_BY_ABBR.put("dec", 12);

        NAMED_TIMEZONE_OFFSET_MINUTES.put("UT", 0);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("GMT", 0);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("UTC", 0);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("Z", 0);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("EST", -300);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("EDT", -240);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("CST", -360);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("CDT", -300);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("MST", -420);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("MDT", -360);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("PST", -480);
        NAMED_TIMEZONE_OFFSET_MINUTES.put("PDT", -420);
    }

    /**
     * Parses an RSS pubDate (RFC 822/2822, e.g. "Wed, 02 Oct 2024 15:00:00 +0000"
     * or "02 Oct 2024 15:00:00 GMT") into epoch milliseconds.
     * <p>
     * Hand-rolled because java.time's built-in RFC-1123 formatter is similarly
     * strict about the exact "GMT"/offset layout that real-world feeds don't
     * reliably follow.
     */
    private Long parseDateMillis(String raw) {
        if (raw == null || raw.isEmpty()) return null;
        String s = raw.trim();

        int commaIndex = s.indexOf(',');
        if (commaIndex != -1) {
            s = s.substring(commaIndex + 1).trim();
        }

        String[] parts = WHITESPACE.split(s);
        if (parts.length < 4) return null;

        Integer day = parseIntOrNull(parts[0]);
        String monthAbbrRaw = parts[1].toLowerCase();
        String monthAbbr = monthAbbrRaw.substring(0, Math.min(3, monthAbbrRaw.length()));
        Integer month = MONTHS_BY_ABBR.get(monthAbbr);
        Integer year = parseIntOrNull(parts[2]);

        String[] timeStrings = parts[3].split(":");
        Integer[] timeParts = new Integer[timeStrings.length];
        for (int i = 0; i < timeStrings.length; i++) {
            timeParts[i] = parseIntOrNull(timeStrings[i]);
        }

        if (day == null || month == null || year == null || timeParts.length < 2) return null;
        for (Integer p : timeParts) {
            if (p == null) return null;
        }

        // Handle 2-digit years per RFC 2822 pivoting rules.
        if (year < 100) {
            year += year < 70 ? 2000 : 1900;
        }

        int hour = timeParts[0];
        int minute = timeParts[1];
        int second = timeParts.length > 2 ? timeParts[2] : 0;

        int offsetMinutes = parts.length > 4 ? parseTimezoneOffsetMinutes(parts[4]) : 0;

        try {
            LocalDateTime ldt = LocalDateTime.of(year, month, day, hour, minute, second);
            Instant instant = ldt.toInstant(ZoneOffset.UTC).minus(offsetMinutes, ChronoUnit.MINUTES);
            return instant.toEpochMilli();
        } catch (Exception e) {
            return null;
        }
    }

    private int parseTimezoneOffsetMinutes(String tz) {
        if (tz.startsWith("+") || tz.startsWith("-")) {
            int sign = tz.startsWith("-") ? -1 : 1;
            String digits = tz.substring(1);
            if (digits.length() == 4) {
                Integer hours = parseIntOrNull(digits.substring(0, 2));
                Integer minutes = parseIntOrNull(digits.substring(2, 4));
                return sign * ((hours != null ? hours : 0) * 60 + (minutes != null ? minutes : 0));
            }
        }
        Integer named = NAMED_TIMEZONE_OFFSET_MINUTES.get(tz.toUpperCase());
        return named != null ? named : 0;
    }

    /**
     * iTunes duration can be plain seconds ("1425") or HH:MM:SS / MM:SS.
     * Returns the total duration in seconds.
     */
    private Long parseDurationSeconds(String raw) {
        if (raw == null || raw.isEmpty()) return null;
        if (!raw.contains(":")) {
            return parseLongOrNull(raw);
        }
        String[] rawParts = raw.split(":");
        long[] parts = new long[rawParts.length];
        for (int i = 0; i < rawParts.length; i++) {
            Long p = parseLongOrNull(rawParts[i]);
            parts[i] = p != null ? p : 0;
        }
        if (parts.length == 3) {
            return parts[0] * 3600 + parts[1] * 60 + parts[2];
        } else if (parts.length == 2) {
            return parts[0] * 60 + parts[1];
        }
        return null;
    }
}
