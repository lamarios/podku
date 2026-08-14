# openapi.api.EpisodesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getEpisode**](EpisodesApi.md#getepisode) | **GET** /api/episodes/{id} | 
[**getEpisodes**](EpisodesApi.md#getepisodes) | **GET** /api/episodes | 
[**search2**](EpisodesApi.md#search2) | **GET** /api/episodes/search | 
[**setProgress**](EpisodesApi.md#setprogress) | **POST** /api/episodes/setProgress | 
[**startPlayback**](EpisodesApi.md#startplayback) | **POST** /api/episodes/startPlayback | 
[**updateProgresses**](EpisodesApi.md#updateprogresses) | **POST** /api/episodes/setProgressesBatch | 


# **getEpisode**
> Episode getEpisode(id)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getEpisodesApi();
final String id = id_example; // String | 

try {
    final response = api.getEpisode(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EpisodesApi->getEpisode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Episode**](Episode.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getEpisodes**
> List<Episode> getEpisodes(before, pageSize)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getEpisodesApi();
final int before = 789; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.getEpisodes(before, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EpisodesApi->getEpisodes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **before** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**List&lt;Episode&gt;**](Episode.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **search2**
> List<Episode> search2(query, limit)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getEpisodesApi();
final String query = query_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.search2(query, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EpisodesApi->search2: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**|  | 
 **limit** | **int**|  | 

### Return type

[**List&lt;Episode&gt;**](Episode.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setProgress**
> setProgress(playbackProgress)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getEpisodesApi();
final PlaybackProgress playbackProgress = ; // PlaybackProgress | 

try {
    api.setProgress(playbackProgress);
} on DioException catch (e) {
    print('Exception when calling EpisodesApi->setProgress: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **playbackProgress** | [**PlaybackProgress**](PlaybackProgress.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startPlayback**
> startPlayback(playbackProgress)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getEpisodesApi();
final PlaybackProgress playbackProgress = ; // PlaybackProgress | 

try {
    api.startPlayback(playbackProgress);
} on DioException catch (e) {
    print('Exception when calling EpisodesApi->startPlayback: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **playbackProgress** | [**PlaybackProgress**](PlaybackProgress.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProgresses**
> bool updateProgresses(requestBody)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getEpisodesApi();
final Map<String, OfflineProgress> requestBody = Object; // Map<String, OfflineProgress> | 

try {
    final response = api.updateProgresses(requestBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EpisodesApi->updateProgresses: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestBody** | [**Map&lt;String, OfflineProgress&gt;**](OfflineProgress.md)|  | 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

