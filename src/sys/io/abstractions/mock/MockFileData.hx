package sys.io.abstractions.mock;

import haxe.io.Bytes;

using Safety;

/**
 * Mock file which stores byte and string data.
 */
@:nullSafety
class MockFileData
{
    /**
     * Raw byte data of the mocked file.
     */
    public var data (default, null) : Bytes;

    /**
     * Text representation of the file data.
     */
    public var text (get, never) : String;

    inline function get_text() : String
    {
        return data.toString();
    }

    function new(_data : Bytes)
    {
        data = _data;
    }

    /**
     * Create a new mock file from the provided bytes. If no bytes are provided 0 bytes are allocated.
     * @param _data Bytes to create the file from.
     * @return MockFileData
     */
    public static function fromBytes(_data : Bytes = null) : MockFileData
    {
        return new MockFileData(_data.or(Bytes.alloc(0)));
    }

    /**
     * Create a new mock file from the provided string. If no string is provided an empty string is used.
     * @param _text String to create the file from.
     * @return MockFileData
     */
    public static function fromText(_text : String = '') : MockFileData
    {
        return new MockFileData(Bytes.ofString(_text));
    }

    /**
     * Sets the file data to the provided bytes.
     * @param _data Bytes data.
     */
    public function setBytes(_data : Bytes)
    {
        data = _data;
    }

    /**
     * Sets the file data to the provided string.
     * @param _text String data.
     */
    public function setText(_text : String)
    {
        data = Bytes.ofString(_text);
    }
}
