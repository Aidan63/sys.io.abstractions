package sys.io.abstractions.mock;

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

        var file = files.get(normalized);
        file!.setText(_text);
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

        var file = files.get(normalized);
        file!.setBytes(_bytes);
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

        var file = files.get(normalized);
        return file!.text.or('');
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

        var file = files.get(normalized);
        return file!.data.or(Bytes.alloc(0));
    }
}
