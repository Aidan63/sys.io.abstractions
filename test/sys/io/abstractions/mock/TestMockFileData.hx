package sys.io.abstractions.mock;

import haxe.io.Bytes;
import buddy.BuddySuite;

using buddy.Should;

class TestMockFileData extends BuddySuite
{
    public function new()
    {
        describe('MockFileData', {
            it('will allocate 0 bytes when not provided any in the static function', {
                final file = MockFileData.fromBytes();
                file.data.length.should.be(0);
                file.text.length.should.be(0);
            });

            it('will set its data to the provided bytes', {
                final file = MockFileData.fromBytes(Bytes.ofString('hello world'));
                file.data.length.should.be(11);
                file.text.should.be('hello world');
            });

            it('will set its bytes data to that of an empty string if no string is provided', {
                final file = MockFileData.fromText();
                file.data.length.should.be(0);
                file.text.length.should.be(0);
            });

            it('will set its bytes data to that of the provided string', {
                final file = MockFileData.fromText('hello world');
                file.data.length.should.be(11);
                file.text.should.be('hello world');
            });

            it('allows updating the file data to bytes', {
                final file = MockFileData.fromBytes();
                file.setBytes(Bytes.alloc(10));
                file.data.length.should.be(10);
                file.text.length.should.be(10);
            });

            it('allows updating the file data to a string', {
                final file = MockFileData.fromBytes();
                file.setText('hello world');
                file.data.length.should.be(11);
                file.text.should.be('hello world');
            });
        });
    }
}
