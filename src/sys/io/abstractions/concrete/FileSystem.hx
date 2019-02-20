package sys.io.abstractions.concrete;

class FileSystem implements IFileSystem
{
    public final directory : IDirectory;

    public final file : IFile;

    public final path : Path;

    public function new()
    {
        directory = new Directory();
        file      = new File();
        path      = new Path();
    }
}
