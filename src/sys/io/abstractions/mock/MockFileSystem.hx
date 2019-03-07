package sys.io.abstractions.mock;

using Safety;

class MockFileSystem implements IFileSystem
{
    public final directory : IDirectory;

    public final file : IFile;

    public final files : Map<String, MockFileData>;

    public final directories : Array<String>;

    public function new(_files : Map<String, MockFileData> = null, _directories : Array<String>)
    {
        files       = _files.or([]);
        directories = _directories.or([]);
        
        directory  = new MockDirectory(files, directories);
        file       = new MockFile(files, directories);
    }
}
