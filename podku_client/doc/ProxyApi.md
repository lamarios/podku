# openapi.api.ProxyApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**proxyImage**](ProxyApi.md#proxyimage) | **GET** /api/images/proxy | 


# **proxyImage**
> Object proxyImage(url, ifNoneMatch)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProxyApi();
final String url = url_example; // String | 
final String ifNoneMatch = ifNoneMatch_example; // String | 

try {
    final response = api.proxyImage(url, ifNoneMatch);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProxyApi->proxyImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **url** | **String**|  | 
 **ifNoneMatch** | **String**|  | [optional] 

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

