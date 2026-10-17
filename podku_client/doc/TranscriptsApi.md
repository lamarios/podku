# openapi.api.TranscriptsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getEpisodeLanguages**](TranscriptsApi.md#getepisodelanguages) | **GET** /api/transcripts/{id}/languages | 
[**getTranscript**](TranscriptsApi.md#gettranscript) | **GET** /api/transcripts/{id}/{language} | 
[**summarizePast5minutes**](TranscriptsApi.md#summarizepast5minutes) | **GET** /api/transcripts/{id}/{language}/summary-until/{until} | 


# **getEpisodeLanguages**
> List<String> getEpisodeLanguages(id)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTranscriptsApi();
final String id = id_example; // String | 

try {
    final response = api.getEpisodeLanguages(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TranscriptsApi->getEpisodeLanguages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

**List&lt;String&gt;**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTranscript**
> List<EpisodeTranscript> getTranscript(id, language)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTranscriptsApi();
final String id = id_example; // String | 
final String language = language_example; // String | 

try {
    final response = api.getTranscript(id, language);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TranscriptsApi->getTranscript: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **language** | **String**|  | 

### Return type

[**List&lt;EpisodeTranscript&gt;**](EpisodeTranscript.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **summarizePast5minutes**
> List<String> summarizePast5minutes(id, language, until)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTranscriptsApi();
final String id = id_example; // String | 
final String language = language_example; // String | 
final int until = 789; // int | 

try {
    final response = api.summarizePast5minutes(id, language, until);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TranscriptsApi->summarizePast5minutes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **language** | **String**|  | 
 **until** | **int**|  | 

### Return type

**List&lt;String&gt;**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/event-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

