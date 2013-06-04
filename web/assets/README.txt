This directory contains all game data such as images, audio, and maps.
All the files in each directory must be indexed in a _.pack file, which
is a JSON formatted file used by the asset_pack library.  The structure
of the file is:

{
	asset_name: {"url": file_path, "type": "json"|"text"|"image"|""},
	asset2_name: ...
}