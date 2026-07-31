# openapi.api.PodcastsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPodcast**](PodcastsApi.md#getpodcast) | **GET** /api/podcasts/{id} | 
[**getPodcasts**](PodcastsApi.md#getpodcasts) | **GET** /api/podcasts | 
[**parsePodcast**](PodcastsApi.md#parsepodcast) | **POST** /api/podcasts/parse | 
[**subscribeToPodcast**](PodcastsApi.md#subscribetopodcast) | **POST** /api/podcasts | 
[**unsubsribe**](PodcastsApi.md#unsubsribe) | **DELETE** /api/podcasts/{id} | 


# **getPodcast**
> Podcast getPodcast(id)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPodcastsApi();
final String id = id_example; // String | 

try {
    final response = api.getPodcast(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PodcastsApi->getPodcast: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Podcast**](Podcast.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPodcasts**
> List<PodcastLight> getPodcasts()



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPodcastsApi();

try {
    final response = api.getPodcasts();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PodcastsApi->getPodcasts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;PodcastLight&gt;**](PodcastLight.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **parsePodcast**
> Podcast parsePodcast(searchResult)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPodcastsApi();
final SearchResult searchResult = ; // SearchResult | 

try {
    final response = api.parsePodcast(searchResult);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PodcastsApi->parsePodcast: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **searchResult** | [**SearchResult**](SearchResult.md)|  | 

### Return type

[**Podcast**](Podcast.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscribeToPodcast**
> Podcast subscribeToPodcast(searchResult)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPodcastsApi();
final SearchResult searchResult = ; // SearchResult | 

try {
    final response = api.subscribeToPodcast(searchResult);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PodcastsApi->subscribeToPodcast: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **searchResult** | [**SearchResult**](SearchResult.md)|  | 

### Return type

[**Podcast**](Podcast.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unsubsribe**
> unsubsribe(id)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPodcastsApi();
final String id = id_example; // String | 

try {
    api.unsubsribe(id);
} on DioException catch (e) {
    print('Exception when calling PodcastsApi->unsubsribe: $e\n');
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

