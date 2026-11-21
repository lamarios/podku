# openapi.api.RecommendationsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getEpisodeRecommendations**](RecommendationsApi.md#getepisoderecommendations) | **GET** /api/episodes/{episodeId}/recommendations | 


# **getEpisodeRecommendations**
> List<SearchResult> getEpisodeRecommendations(episodeId, limit)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getRecommendationsApi();
final String episodeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int limit = 56; // int | 

try {
    final response = api.getEpisodeRecommendations(episodeId, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RecommendationsApi->getEpisodeRecommendations: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **episodeId** | **String**|  | 
 **limit** | **int**|  | [optional] [default to 6]

### Return type

[**List&lt;SearchResult&gt;**](SearchResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

