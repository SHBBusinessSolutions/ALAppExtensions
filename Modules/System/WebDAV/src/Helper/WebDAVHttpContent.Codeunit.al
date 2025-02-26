// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 5686 "WebDAV Http Content"
{
    Access = Internal;

    var
        HttpContent: HttpContent;
        ContentLength: Integer;
        ContentType: Text;
        RequestDigest: Text;

    procedure FromFileInStream(var ContentInStream: Instream)
    begin
        HttpContent.WriteFrom(ContentInStream);
        ContentLength := GetContentLength(ContentInStream);
    end;

    procedure FromText(Content: Text)
    var
        InStream: InStream;
    begin
        HttpContent.WriteFrom(Content);
        HttpContent.ReadAs(InStream);
        ContentLength := GetContentLength(InStream);
    end;

    procedure FromXML(XMLDoc: XmlDocument)
    var
        RequestText: Text;
    begin
        XMLDoc.WriteTo(RequestText);
        HttpContent.WriteFrom(RequestText);
        ContentLength := StrLen(RequestText);
    end;

    procedure GetContent(): HttpContent
    begin
        exit(HttpContent);
    end;

    procedure GetContentLength(): Integer
    begin
        exit(ContentLength);
    end;

    procedure GetContentType(): Text
    begin
        exit(ContentType);
    end;

    // TODO DIGEST??
    procedure SetRequestDigest(RequestDigestValue: Text)
    begin
        RequestDigest := RequestDigestValue;
    end;

    procedure GetRequestDigest(): Text;
    begin
        exit(RequestDigest);
    end;

    local procedure GetContentLength(var SourceInStream: InStream) Length: Integer
    var
        MemoryStream: DotNet MemoryStream;
    begin
        MemoryStream := MemoryStream.MemoryStream();
        CopyStream(MemoryStream, SourceInStream);
        Length := MemoryStream.Length;
        Clear(SourceInStream);
    end;

}