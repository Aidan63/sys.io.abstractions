package sys.io.abstractions.concrete;

import haxe.io.Bytes;

/**
 * //
 */
class File implements IFile
{
    public function new()
    {
        //
    }

    /**
     * //
     * @param _path //
     */
    public function create(_path : String)
    {
        sys.io.File.saveContent(_path, '');
    }

    /**
     * //
     * @param _path //
     */
    public function remove(_path : String)
    {
        sys.FileSystem.deleteFile(_path);
    }

    /**
     * //
     * @param _path //
     * @return Bool
     */
    public function exists(_path : String) : Bool
    {
        return sys.FileSystem.exists(_path);
    }

    /**
     * //
     * @param _path //
     * @param _text //
     */
    public function writeText(_path : String, _text : String)
    {
        sys.io.File.saveContent(_path, _text);
    }

    /**
     * //
     * @param _path //
     * @param _bytes //
     */
    public function writeBytes(_path : String, _bytes : Bytes)
    {
        sys.io.File.saveBytes(_path, _bytes);
    }

    /**
     * //
     * @param _path //
     * @param _text //
     */
    public function appendText(_path : String, _text : String)
    {
        var out = sys.io.File.append(_path, false);
        out.writeString(_text);
        out.close();
    }

    /**
     * //
     * @param _path //
     * @param _bytes //
     */
    public function appendBytes(_path : String, _bytes : Bytes)
    {
        var out = sys.io.File.append(_path);
        out.writeBytes(_bytes, 0, _bytes.length);
        out.close();
    }

    /**
     * //
     * @param _path //
     * @return String
     */
    public function getText(_path : String) : String
    {
        return sys.io.File.getContent(_path);
    }

    /**
     * //
     * @param _path //
     * @return Bytes
     */
    public function getBytes(_path : String) : Bytes
    {
        return sys.io.File.getBytes(_path);
    }
}
