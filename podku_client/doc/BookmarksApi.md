# openapi.api.BookmarksApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**callGet**](BookmarksApi.md#callget) | **GET** /api/bookmarks | 
[**delete**](BookmarksApi.md#delete) | **DELETE** /api/bookmarks/{id} | 
[**get1**](BookmarksApi.md#get1) | **GET** /api/bookmarks/{id} | 
[**saveBookmark**](BookmarksApi.md#savebookmark) | **PUT** /api/bookmarks | 


# **callGet**
> List<BookmarkWithTranscript> callGet()



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBookmarksApi();

try {
    final response = api.callGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling BookmarksApi->callGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;BookmarkWithTranscript&gt;**](BookmarkWithTranscript.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **delete**
> delete(id)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBookmarksApi();
final String id = id_example; // String | 

try {
    api.delete(id);
} on DioException catch (e) {
    print('Exception when calling BookmarksApi->delete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **get1**
> BookmarkWithTranscript get1(id)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBookmarksApi();
final String id = id_example; // String | 

try {
    final response = api.get1(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BookmarksApi->get1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**BookmarkWithTranscript**](BookmarkWithTranscript.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveBookmark**
> saveBookmark(bookmark)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBookmarksApi();
final Bookmark bookmark = ; // Bookmark | 

try {
    api.saveBookmark(bookmark);
} on DioException catch (e) {
    print('Exception when calling BookmarksApi->saveBookmark: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookmark** | [**Bookmark**](Bookmark.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

