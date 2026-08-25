package com.github.lamarios.podku.bookmarks;

import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/** REST API for managing user bookmarks on episodes. */
@RestController
@RequestMapping("/api/bookmarks")
@Tag(name = "Bookmarks")
public class BookmarkController {

  private final BookmarkService bookmarkService;

  /**
   * @param bookmarkService service performing the bookmark persistence logic
   */
  @Autowired
  public BookmarkController(BookmarkService bookmarkService) {
    this.bookmarkService = bookmarkService;
  }

  /**
   * Creates or updates a bookmark.
   *
   * @param bookmark the bookmark payload to save
   */
  @PutMapping
  public void saveBookmark(@RequestBody Bookmark bookmark) {
    bookmarkService.saveBookmark(bookmark);
  }

  /**
   * Lists all bookmarks, each enriched with its associated transcript.
   *
   * @return all stored bookmarks
   */
  @GetMapping
  public List<BookmarkWithTranscript> get() {
    return bookmarkService.getBookmarks();
  }

  /**
   * Fetches a single bookmark by identifier.
   *
   * @param id UUID of the bookmark
   * @return the bookmark with its transcript
   */
  @GetMapping("/{id}")
  public BookmarkWithTranscript get(@PathVariable("id") String id) {
    return bookmarkService.getBookmark(UUID.fromString(id));
  }

  /**
   * Deletes a bookmark by identifier.
   *
   * @param id UUID of the bookmark to delete
   */
  @DeleteMapping("/{id}")
  public void delete(@PathVariable("id") String id) {
    bookmarkService.deleteBookmark(UUID.fromString(id));
  }
}
