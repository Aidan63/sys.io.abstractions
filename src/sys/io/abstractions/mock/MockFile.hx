package sys.io.abstractions.mock;

import haxe.io.BytesBuffer;
import haxe.io.Bytes;

using Safety;

/**
 * //
 */
class MockFile implements IFile
{
    final files : Map<String, MockFileData>;

    final directories : Array<String>;

    public function new(_file : Map<String, MockFileData>, _directories : Array<String>)
    {
        files = _file;
        directories = _directories;
    }

    /**
     * //
     * @param _path //
     */
    public function create(_path : String)
    {
        files.set(haxe.io.Path.normalize(_path), MockFileData.fromBytes());
        directories.push(haxe.io.Path.directory(haxe.io.Path.normalize(_path)));
    }

    /**
     * //
     * @param _path //
     */
    public function remove(_path : String)
    {
        files.remove(haxe.io.Path.normalize(_path));
        directories.remove(haxe.io.Path.directory(haxe.io.Path.normalize(_path)));
    }

    /**
     * //
     * @param _path //
     * @return Bool
     */
    public function exists(_path : String) : Bool
    {
        return files.exists(haxe.io.Path.normalize(_path));
    }

    /**
     * //
     * @param _path //
     * @param _text //
     */
    public function writeText(_path : String, _text : String)
    {
        if (files.exists(haxe.io.Path.normalize(_path)))
        {
            var file = files.get(haxe.io.Path.normalize(_path));
            file!.setText(_text);
        }
    }

    /**
     * //
     * @param _path //
     * @param _bytes //
     */
    public function writeBytes(_path : String, _bytes : Bytes)
    {
        if (files.exists(haxe.io.Path.normalize(_path)))
        {
            var file = files.get(haxe.io.Path.normalize(_path));
            file!.setBytes(_bytes);
        }
    }

    /**
     * //
     * @param _path //
     * @param _text //
     */
    public function appendText(_path : String, _text : String)
    {
        if (files.exists(haxe.io.Path.normalize(_path)))
        {
            var file = files.get(haxe.io.Path.normalize(_path));
            if (file != null)
            {
                file.setText(file.text + _text);
            }
        }
    }

    /**
     * //
     * @param _path //
     * @param _bytes //
     */
    public function appendBytes(_path : String, _bytes : Bytes)
    {
        if (files.exists(haxe.io.Path.normalize(_path)))
        {
            var file = files.get(haxe.io.Path.normalize(_path));
            if (file != null)
            {
                var data = new BytesBuffer();
                data.add(file.data);
                data.add(_bytes);

                file.setBytes(data.getBytes());
            }
        }
    }

    /**
     * //
     * @param _path //
     * @return String
     */
    public function getText(_path : String) : String
    {
        if (files.exists(haxe.io.Path.normalize(_path)))
        {
            var file = files.get(haxe.io.Path.normalize(_path));
            return file!.text.or('');
        }

        return '';
    }

    /**
     * //
     * @param _path //
     * @return Bytes
     */
    public function getBytes(_path : String) : Bytes
    {
        if (files.exists(haxe.io.Path.normalize(_path)))
        {
            var file = files.get(haxe.io.Path.normalize(_path));
            return file!.data.or(Bytes.alloc(0));
        }

        return Bytes.alloc(0);
    }
}
