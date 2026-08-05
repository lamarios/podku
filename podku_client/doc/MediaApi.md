# openapi.api.MediaApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getImage**](MediaApi.md#getimage) | **GET** /media/image/{hash} | 
[**proxyAudio**](MediaApi.md#proxyaudio) | **GET** /media/audio/{hash} | 


# **getImage**
> Object getImage(hash, ifNoneMatch)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMediaApi();
final String hash = hash_example; // String | 
final String ifNoneMatch = ifNoneMatch_example; // String | 

try {
    final response = api.getImage(hash, ifNoneMatch);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MediaApi->getImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hash** | **String**|  | 
 **ifNoneMatch** | **String**|  | [optional] 

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **proxyAudio**
> Object proxyAudio(hash, range)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMediaApi();
final String hash = hash_example; // String | 
final String range = range_example; // String | 

try {
    final response = api.proxyAudio(hash, range);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MediaApi->proxyAudio: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hash** | **String**|  | 
 **range** | **String**|  | [optional] 

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

