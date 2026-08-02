# openapi.api.SearchApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**search**](SearchApi.md#search) | **GET** /api/search | 


# **search**
> List<SearchResult> search(query, limit)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSearchApi();
final String query = query_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.search(query, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->search: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**|  | 
 **limit** | **int**|  | 

### Return type

[**List&lt;SearchResult&gt;**](SearchResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

