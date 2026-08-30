package com.github.lamarios.podku.utils;

import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.models.ReasoningEffort;
import com.openai.models.chat.completions.ChatCompletionCreateParams;
import com.openai.models.chat.completions.StructuredChatCompletionCreateParams;
import com.openai.models.models.Model;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service("openaiService")
public class OpenaiServiceImpl implements OpenaiService {
  private static final Logger logger = LogManager.getLogger();
  private final String url;
  private final String apiKey;
  private final String model;

  @Autowired
  public OpenaiServiceImpl(
      @Value("${OPENAI_URL:}") String url,
      @Value("${OPENAI_API_KEY:}") String apiKey,
      @Value("${OPENAI_MODEL:}") String model) {
    this.url = url;
    this.apiKey = apiKey;
    this.model = model;

    if (!url.isEmpty()) {

      var models = getClient().models().list();
      List<String> modelList = new ArrayList<>();
      while (models.hasNextPage() || !models.data().isEmpty()) {
        modelList.addAll(models.data().stream().map(Model::id).toList());
        if (models.hasNextPage()) {
          models = models.nextPage();
        } else {
          break;
        }
      }

      logger.info("Available models: {}", String.join(",", modelList));
      if (!modelList.contains(model)) {
        throw new RuntimeException("Model " + model + " not available");
      }
    } else {
      logger.info("OpenAI API not in use");
    }
  }

  @Override
  public boolean enabled() {
    return !url.isEmpty();
  }

  private OpenAIClient getClient() {
    var client = OpenAIOkHttpClient.builder().baseUrl(url).checkJacksonVersionCompatibility(false);

    if (apiKey != null) {
      client = client.apiKey(apiKey);
    } else {
      client = client.apiKey("");
    }

    client.timeout(Duration.ofMinutes(2));

    return client.build();
  }

  @Override
  public Optional<BookmarkTopicResponse> getBookmarkTopic(
      EpisodeTranscript bookmarkedTranscript, List<EpisodeTranscript> surroundingTranscript) {
    if (!enabled()) {
      return Optional.empty();
    }

    logger.info("Finding topic for bookmark: {}", bookmarkedTranscript.getContent());
    var start = System.currentTimeMillis();
    String prompt =
        """
                this a snippet of transcript of a podcast:

                %s

                the user bookmarked the line:
                %s

                Can you find what is the topic of the conversation that the user bookmarked. Your answer will just contain the topic.
                """
            .formatted(
                surroundingTranscript.stream()
                    .map(t -> t.getStartTime() + ": " + t.getContent())
                    .collect(Collectors.joining("\n")),
                bookmarkedTranscript.getStartTime() + ": " + bookmarkedTranscript.getContent());

    StructuredChatCompletionCreateParams<BookmarkTopicResponse> params =
        ChatCompletionCreateParams.builder()
            .addUserMessage(prompt)
            .model(model)
            .reasoningEffort(ReasoningEffort.NONE)
            .responseFormat(BookmarkTopicResponse.class)
            .build();

    List<BookmarkTopicResponse> analysis =
        getClient().chat().completions().create(params).choices().stream()
            .flatMap(choice -> choice.message().content().stream())
            .toList();

    Optional<BookmarkTopicResponse> first = analysis.stream().findFirst();
    first.ifPresent(
        openAiFeedResponse ->
            logger.info(
                "Topic found: {}\nProcessing time: {}",
                openAiFeedResponse.topic(),
                (System.currentTimeMillis() - start) / 1000));
    return first;
  }
}
