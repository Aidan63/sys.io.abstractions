package sys.io.abstractions.mock;

import buddy.BuddySuite;

using Lambda;
using buddy.Should;

class TestMockDirectory extends BuddySuite
{
    public function new()
    {
        describe('TestMockDirectory', {
            describe('checking for a directory', {
                var f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromBytes(),
                    '/home/user/documents/some/other/file2.txt' => MockFileData.fromBytes()
                ];
                var d = [ '/media/user/archive/' ];
                var directories = new MockDirectory(f, d);

                it('can detect explicitly defined directories', {
                    directories.exist('/media/user').should.be(true);
                    directories.exist('/media/user/archive/').should.be(true);
                    directories.exist('/media/user/archive/folder').should.be(false);
                    directories.exist('/media/user/external').should.be(false);
                });

                it('can detect directories from existing files', {
                    directories.exist('/home/user').should.be(true);
                    directories.exist('/home/user/documents').should.be(true);
                    directories.exist('/home/user/documents/some').should.be(true);
                    directories.exist('/home/user/documents/other').should.be(false);
                });
            });

            describe('creating a directory', {
                var d = [];
                var directories = new MockDirectory([], d);

                it('can add a new directory', {
                    directories.create('/home/user/documents/some/');
                    d.has('/home/user/documents/some/').should.be(true);
                });

                it('will normalize the path when creating the directory', {
                    directories.create('/home/user/documents/some/other/../directory/');
                    d.has('/home/user/documents/some/directory/').should.be(true);
                });

                it('will add a trailing slash to the path', {
                    directories.create('/home/user/documents/some');
                    d.has('/home/user/documents/some${sys.io.abstractions.Path.separator}').should.be(true);
                });
            });

            describe('removing a directory', {
                var f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromText(),
                    '/home/user/documents/folder/file.txt' => MockFileData.fromText(),
                    '/home/user/file3.txt' => MockFileData.fromText()
                ];
                var d = [ '/home/user/documents/folder/other/', '/media/user/archive/pictures' ];
                var directories = new MockDirectory(f, d);

                it('can remove a directory and all sub directories and files', {
                    directories.remove('/home/user/documents');
                    f.exists('/home/user/documents/file1.txt').should.be(false);
                    f.exists('/home/user/documents/folder/file2.txt').should.be(false);
                    d.has('/home/user/documents/folder/other/').should.be(false);
                });
            });

            describe('reading a directory', {
                var f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromText(),
                    '/home/user/documents/folder/file2.txt' => MockFileData.fromText(),
                    '/home/user/documents/folder/file3.txt' => MockFileData.fromText(),
                    '/home/user/file4.txt' => MockFileData.fromText()
                ];
                var d = [ '/home/user/documents/folder/other/', '/media/user/archive/pictures' ];
                var directories = new MockDirectory(f, d);

                it('can fetch a files of all files and directories within a directory', {
                    directories.read('/home/user/documents').should.containAll([ '/home/user/documents/file1.txt', '/home/user/documents/folder' ]);
                });

                it('will normalize the input path and read fetch all files and directories within the directory', {
                    directories.read('/home/user/documents/other/..').should.containAll([ '/home/user/documents/file1.txt', '/home/user/documents/folder' ]);
                });
            });

            describe('detecting if a path is a directory', {
                var f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromText(),
                    '/home/user/documents/folder/file2.txt' => MockFileData.fromText(),
                    '/home/user/documents/folder/file3.txt' => MockFileData.fromText(),
                    '/home/user/file4.txt' => MockFileData.fromText()
                ];
                var d = [ '/home/user/documents/folder/other/', '/media/user/archive/pictures' ];
                var directories = new MockDirectory(f, d);

                it('will return if a path is a directory', {
                    directories.isDirectory('/home/user/documents/file1.txt').should.be(false);
                    directories.isDirectory('/home/user/documents/').should.be(true);
                    directories.isDirectory('/home/user').should.be(true);
                    directories.isDirectory('/home/user/documents/folder/file2.txt').should.be(false);
                });

                it('will normalize a path and return if its a directory', {
                    directories.isDirectory('/home/user/documents/other/../file1.txt').should.be(false);
                    directories.isDirectory('/home/user/documents/other/../').should.be(true);
                });
            });
        });
    }
}
