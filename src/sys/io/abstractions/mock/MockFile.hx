package sys.io.abstractions.mock;

import haxe.io.BytesInput;
import haxe.io.Output;
import haxe.io.Input;
import haxe.io.BytesBuffer;
import haxe.io.Bytes;
import sys.io.abstractions.exceptions.ArgumentException;
import sys.io.abstractions.exceptions.NotFoundException;

using StringTools;
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
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        files.set(normalized, MockFileData.fromBytes());
    }

    /**
     * //
     * @param _path //
     */
    public function remove(_path : String)
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!exists(normalized))
        {
            throw new NotFoundException('${normalized} not found');
        }

        files.remove(normalized);
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
     * @return Input
     */
    public function read(_path : String) : Input
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!exists(normalized))
        {
            throw new NotFoundException('${normalized} not found');
        }

        return new BytesInput(files.get(normalized).sure().data);
    }

    /**
     * //
     * @param _path //
     * @return Output
     */
    public function write(_path : String) : Output
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!exists(normalized))
        {
            throw new NotFoundException('${normalized} not found');
        }

        return new MockFileOutput(files.get(normalized).sure());
    }

    /**
     * //
     * @param _path //
     * @param _text //
     */
    public function writeText(_path : String, _text : String)
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!exists(normalized))
        {
            throw new NotFoundException('${normalized} not found');
        }

        files.get(normalized).sure().setText(_text);
    }

    /**
     * //
     * @param _path //
     * @param _bytes //
     */
    public function writeBytes(_path : String, _bytes : Bytes)
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!exists(normalized))
        {
            throw new NotFoundException('${normalized} not found');
        }

        files.get(normalized).sure().setBytes(_bytes);
    }

    /**
     * //
     * @param _path //
     * @param _text //
     */
    public function appendText(_path : String, _text : String)
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!exists(normalized))
        {
            throw new NotFoundException('${normalized} not found');
        }

        var file = files.get(normalized);
        if (file != null)
        {
            file.setText(file.text + _text);
        }
    }

    /**
     * //
     * @param _path //
     * @param _bytes //
     */
    public function appendBytes(_path : String, _bytes : Bytes)
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!exists(normalized))
        {
            throw new NotFoundException('${normalized} not found');
        }

        var file = files.get(normalized);
        if (file != null)
        {
            var data = new BytesBuffer();
            data.add(file.data);
            data.add(_bytes);

            file.setBytes(data.getBytes());
        }
    }

    /**
     * //
     * @param _path //
     * @return String
     */
    public function getText(_path : String) : String
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!exists(normalized))
        {
            throw new NotFoundException('${normalized} not found');
        }

        return files.get(normalized).sure().text;
    }

    /**
     * //
     * @param _path //
     * @return Bytes
     */
    public function getBytes(_path : String) : Bytes
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!exists(normalized))
        {
            throw new NotFoundException('${normalized} not found');
        }

        return files.get(normalized).sure().data;
    }
}

private class MockFileOutput extends Output
{
    final file : MockFileData;

    final buffer : BytesBuffer;

    public function new(_file : MockFileData)
    {
        file   = _file;
        buffer = new BytesBuffer();
        buffer.addBytes(file.data, 0, file.data.length);
    }

    override function writeByte(_byte : Int)
    {
        buffer.addByte(_byte);
    }

    override function close()
    {
        file.setBytes(buffer.getBytes());
    }
}
