package sys.io.abstractions.concrete;

class FileSystem implements IFileSystem
{
    public final directory : IDirectory;

    public final file : IFile;

    public function new()
    {
        directory = new Directory();
        file      = new File();
    }
}
