// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 5684 "WebDAV Operation Response"
{
    Access = Internal;

    var
        TempBlobContent: Codeunit "Temp Blob";
        WebDAVDiagnostics: Codeunit "WebDAV Diagnostics";
        HttpHeaders: HttpHeaders;

    [TryFunction]
    internal procedure TryGetResponseAsText(var Response: Text);
    var
        ResponseInStream: InStream;
    begin
        TempBlobContent.CreateInStream(ResponseInStream);
        ResponseInStream.Read(Response);
    end;

    [TryFunction]
    internal procedure TryGetResponseAsStream(var ResponseInStream: InStream)
    begin
        TempBlobContent.CreateInStream(ResponseInStream);
    end;

    internal procedure SetHttpResponse(HttpResponseMessage: HttpResponseMessage)
    var
        ContentOutStream: OutStream;
        ContentInStream: InStream;
    begin

        TempBlobContent.CreateOutStream(ContentOutStream);
        HttpResponseMessage.Content().ReadAs(ContentInStream);
        CopyStream(ContentOutStream, ContentInStream);
        HttpHeaders := HttpResponseMessage.Headers();

        WebDAVDiagnostics.SetParameters(HttpResponseMessage.IsSuccessStatusCode, HttpResponseMessage.HttpStatusCode, HttpResponseMessage.ReasonPhrase, GetRetryAfterHeaderValue(), GetErrorDescription());
    end;

    internal procedure SetHttpResponse(ResponseContent: Text; ResponseHttpHeaders: HttpHeaders; ResponseHttpStatusCode: Integer; ResponseIsSuccessStatusCode: Boolean; ResponseReasonPhrase: Text)
    var
        ContentOutStream: OutStream;
    begin
        TempBlobContent.CreateOutStream(ContentOutStream);
        ContentOutStream.WriteText(ResponseContent);
        HttpHeaders := ResponseHttpHeaders;
        WebDAVDiagnostics.SetParameters(ResponseIsSuccessStatusCode, ResponseHttpStatusCode, ResponseReasonPhrase, GetRetryAfterHeaderValue(), GetErrorDescription());
    end;

    internal procedure GetHeaderValueFromResponseHeaders(HeaderName: Text): Text
    var
        Values: array[100] of Text;
    begin
        if not HttpHeaders.GetValues(HeaderName, Values) then
            exit('');
        exit(Values[1]);
    end;

    internal procedure GetRetryAfterHeaderValue() RetryAfter: Integer;
    var
        HeaderValue: Text;
    begin
        HeaderValue := GetHeaderValueFromResponseHeaders('Retry-After');
        if HeaderValue = '' then
            exit(0);
        if not Evaluate(RetryAfter, HeaderValue) then
            exit(0);
    end;

    local procedure GetErrorDescription(): Text
    var
        Response: Text;
        JObject: JsonObject;
        JToken: JsonToken;
    begin
        TryGetResponseAsText(Response);
        if Response <> '' then
            if JObject.ReadFrom(Response) then
                if JObject.Get('error_description', JToken) then
                    exit(JToken.AsValue().AsText());
    end;

    internal procedure GetDiagnostics(): Interface "HTTP Diagnostics"
    begin
        exit(WebDAVDiagnostics);
    end;
}
