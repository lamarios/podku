package com.github.lamarios.podku.bookmarks;

import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/bookmarks")
@Tag(name = "Bookmarks")
public class BookmarkController {

  private final BookmarkService bookmarkService;

  @Autowired
  public BookmarkController(BookmarkService bookmarkService) {
    this.bookmarkService = bookmarkService;
  }

  @PutMapping
  public void saveBookmark(@RequestBody Bookmark bookmark) {
    bookmarkService.saveBookmark(bookmark);
  }

  @GetMapping
  public List<BookmarkWithTranscript> get() {
    return bookmarkService.getBookmarks();
  }

  @GetMapping("/{id}")
  public BookmarkWithTranscript get(@PathVariable("id") String id) {
    return bookmarkService.getBookmark(UUID.fromString(id));
  }

  @DeleteMapping("/{id}")
  public void delete(@PathVariable("id") String id) {
    bookmarkService.deleteBookmark(UUID.fromString(id));
  }
}
