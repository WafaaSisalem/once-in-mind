import 'dart:io';

class JournalAttachment {
  JournalAttachment.remote({required this.storagePath, this.signedUrl})
    : file = null;

  JournalAttachment.local(this.file) : storagePath = null, signedUrl = null;

  final String? storagePath;
  final String? signedUrl;
  final File? file;

  bool get isRemote => storagePath != null;
  bool get isLocal => file != null;
}
