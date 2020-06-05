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
 * Mock file class for easy testing.
 */
class MockFile implements IFile
{
    /**
     * All files and their path in the mock file system.
     */
    final files : Map<String, MockFileData>;

    /**
     * Exising directories which may not have files in them.
     */
    final directories : Array<String>;

    public function new(_file : Map<String, MockFileData>, _directories : Array<String>)
    {
        files = _file;
        directories = _directories;
    }

    /**
     * Create a file if it does not exist.
     * @param _path File to create.
     * @throws ArgumentException If the provided path if whitespace.
     */
    public function create(_path : String)
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!files.exists(normalized))
        {
            files.set(normalized, MockFileData.fromBytes());
        }
    }

    /**
     * Removes a file from the hard drive.
     * @param _path File to remove.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist.
     */
    public function remove(_path : String)
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        files.remove(normalized);
    }

    /**
     * Checks if a file exists.
     * @param _path File to check.
     * @return Bool
     */
    public function exists(_path : String) : Bool
    {
        return files.exists(haxe.io.Path.normalize(_path));
    }

    /**
     * Provides a `haxe.io.Input` stream to read data from a file.
     * @param _path File to read.
     * @return Input
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist.
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
     * Provides a `haxe.io.Output` stream to write data to a file.
     * `close` must be called on the stream to ensure data is flushed.
     * @param _path File to write to.
     * @return Output
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist.
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
     * Replaces the contents of a file with the provided string.
     * @param _path File to write to.
     * @param _text String for the file.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist.
     */
    public function writeText(_path : String, _text : String)
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        files.set(normalized, MockFileData.fromText(_text));
    }

    /**
     * Replaces the contents of a file with the provided bytes.
     * @param _path File to write to.
     * @param _bytes Bytes for the file.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
     */
    public function writeBytes(_path : String, _bytes : Bytes)
    {
        var normalized = haxe.io.Path.normalize(_path);

        if (normalized.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        files.set(normalized, MockFileData.fromBytes(_bytes));
    }

    /**
     * Appends a string to the end of a file.
     * @param _path File to append to.
     * @param _text String to append.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
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
     * Appends bytes to the end of a file.
     * @param _path File to append to.
     * @param _bytes Bytes to append.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
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
     * Get a string representation of a files contents.
     * @param _path File to read.
     * @return String
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
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
     * Gets the raw bytes of a file.
     * @param _path File to read.
     * @return Bytes
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
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

    /**
     * Move a file to another location.
     * @param _src File to move.
     * @param _dst Destination to copy to.
     * @throws ArgumentException If the provided path is whitespace.
     * @throws NotFoundException If the source file does not exist.
     */
    public function move(_src : String, _dst : String)
    {
        final src = haxe.io.Path.normalize(_src);
        final dst = haxe.io.Path.normalize(_dst);

        if (src.trim().length == 0)
        {
            throw new ArgumentException('Source path is only whitespace');
        }
        if (dst.trim().length == 0)
        {
            throw new ArgumentException('Destination path is only whitespace');
        }

        if (!exists(src))
        {
            throw new NotFoundException('$src not found');
        }

        files.set(dst, files.get(src).sure());
        files.remove(src);
    }

    /**
     * Copy the contents of a file to another file.
     * @param _src File to read from.
     * @param _dst File to copy to.
     * @throws ArgumentException If the provided path is whitespace.
     * @throws NotFoundException If the source file does not exist.
     */
    public function copy(_src : String, _dst : String)
    {
        final src = haxe.io.Path.normalize(_src);
        final dst = haxe.io.Path.normalize(_dst);

        if (src.trim().length == 0)
        {
            throw new ArgumentException('Source path is only whitespace');
        }
        if (dst.trim().length == 0)
        {
            throw new ArgumentException('Destination path is only whitespace');
        }

        if (!exists(src))
        {
            throw new NotFoundException('$src not found');
        }

        files.set(dst, MockFileData.fromBytes(files.get(src).sure().data));
    }
}

/**
 * Custom output stream for mock files.
 * Copies existing file bytes into a bytes buffer and copies the new bytes into the file when closing.
 */
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
