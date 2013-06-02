/*
  Copyright (C) 2013 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/

part of asset_pack;

class AssetPackTraceEvent {
  static const packImportStart = 'PackImportStart';
  static const packImportEnd = 'PackImportEnd';
  static const assetLoadStart = 'AssetLoadStart';
  static const assetLoadEnd = 'AssetLoadEnd';
  static const assetLoadError = 'AssetLoadError';
  static const assetImportStart = 'AssetImportStart';
  static const assetImportEnd = 'AssetImportEnd';
  static const assetImportError = 'AssetImportError';

  final String type;
  final String label;
  final int microseconds;
  AssetPackTraceEvent(this.type, this.label, this.microseconds );

  dynamic toJson() {
    Map json = new Map();
    json['type'] = type;
    json['label'] = label;
    json['timestamp'] = microseconds;
  }

  String toString() {
    return '${microseconds}, ${type}, ${label}';
  }
}

class AssetPackTraceLabelSummary {
  final String label;
  final List<AssetPackTraceEvent> events = new List<AssetPackTraceEvent>();
  AssetPackTraceLabelSummary(this.label);
  void dump() {
    events.forEach((event) {
      print(event);
    });
  }
}

class AssetPackTraceSummary {
  final Map<String, AssetPackTraceLabelSummary> summaries =
      new Map<String, AssetPackTraceLabelSummary>();

  AssetPackTraceSummary(List<AssetPackTraceEvent> events) {
    for (int i = 0; i < events.length; i++) {
      var event = events[i];
      var summary = summaries[event.label];
      if (summary == null) {
        summary = new AssetPackTraceLabelSummary(event.label);
        summaries[event.label] = summary;
      }
      summary.events.add(event);
    }
    summaries.forEach((k, v) {
      v.events.sort((a, b) => a.microseconds.compareTo(b.microseconds));
    });
  }

  void dump() {
    summaries.forEach((k, v) {
      v.dump();
    });
  }
}

/**
 * Convert event(s) into a json in the format loadable by chrome://tracing
 *
 * * see [Using Chrome://tracing to view your inline profiling data](http://www.altdevblogaday.com/2012/08/21/using-chrometracing-to-view-your-inline-profiling-data/)
 * * see [TraceEventFormat](https://code.google.com/p/trace-viewer/wiki/TraceEventFormat)
 */
class AssetPackTraceViewer {

  static String toJsonFullString(List<AssetPackTraceEvent> events) {
    var lists = events.map(toJsonEntry).toList();
    return '{"traceEvents":${JSON.stringify(lists)}}';
  }

  static dynamic toJsonEntry(AssetPackTraceEvent event) {
    Map json = new Map();
    json['ts'] = event.microseconds;
    var type = event.type;
    if (type == 'AssetImportEnd') {
      json['ph'] = 'E';
      json['name'] = 'import ${event.label}';
    } else if (type == AssetPackTraceEvent.assetImportStart) {
      json['ph'] = 'B';
      json['name'] = 'import ${event.label}';
    } else if (type == AssetPackTraceEvent.assetLoadStart) {
      json['ph'] = 'B';
      json['name'] = 'load ${event.label}';
    } else if (type == AssetPackTraceEvent.assetLoadEnd) {
      json['ph'] = 'E';
      json['name'] = 'load ${event.label}';
    } else if (type == AssetPackTraceEvent.packImportEnd) {
      json['ph'] = 'E';
      json['name'] = 'pack ${event.label}';
    } else if (type == AssetPackTraceEvent.packImportStart) {
      json['ph'] = 'B';
      json['name'] = 'pack ${event.label}';
    } else if (type == AssetPackTraceEvent.assetLoadError
        || type == AssetPackTraceEvent.assetImportError) {
      json['ph'] = 'I';
      json['name'] = '${event.type} ${event.label}';
    } else {
      throw new ArgumentError('Unknown type ${type}');
      assert(false);
    }
    json['cat'] = 'asset';
    json['tid'] = 1;
    json['pid'] = 1;
    return json;
  }
}

class AssetPackTrace {
  final _streamCtrl = new StreamController<AssetPackTraceEvent>();

  Stream<AssetPackTraceEvent> asStream() => _streamCtrl.stream;

  void packImportStart(Asset asset) =>
    assetEvent(asset, AssetPackTraceEvent.packImportStart, null);

  void packImportEnd(Asset asset) =>
    assetEvent(asset, AssetPackTraceEvent.packImportEnd, null);

  void assetLoadStart(Asset asset) =>
    assetEvent(asset, AssetPackTraceEvent.assetLoadStart, null);

  void assetLoadEnd(Asset asset) =>
    assetEvent(asset, AssetPackTraceEvent.assetLoadEnd, null);

  void assetLoadError(Asset asset, String errorLabel) =>
    assetEvent(asset, AssetPackTraceEvent.assetLoadError, errorLabel);

  void assetImportStart(Asset asset) =>
    assetEvent(asset, AssetPackTraceEvent.assetImportStart, null);

  void assetImportEnd(Asset asset) =>
    assetEvent(asset, AssetPackTraceEvent.assetImportEnd, null);

  void assetImportError(Asset asset, String errorLabel) =>
    assetEvent(asset, AssetPackTraceEvent.assetImportError, errorLabel);

  void assetEvent(Asset asset, String type, String msg) {
    var label = (msg == null) ? asset.url : "${asset.url} >> ${msg}";
    var now = (window.performance.now() * 1000).toInt();
    var event = new AssetPackTraceEvent(type, label, now);
    _streamCtrl.add(event);
  }

}

/// An [AssetPackTrace] that doesn't trace anything.
///
/// Used to turn off tracing.
class NullAssetPackTrace extends AssetPackTrace {
  void packImportStart(Asset asset) {}
  void packImportEnd(Asset asset) {}
  void assetLoadStart(Asset asset) {}
  void assetLoadEnd(Asset asset) {}
  void assetLoadError(Asset asset, String errorLabel) {}
  void assetImportStart(Asset asset) {}
  void assetImportEnd(Asset asset) {}
  void assetImportError(Asset asset, String errorLabel) {}
  void assetEvent(Asset asset, String type, String msg) {}
}

class AssetPackTraceEventAccumulator {
  final List<AssetPackTraceEvent> events = new List<AssetPackTraceEvent>();

  onEvent(AssetPackTraceEvent e) => events.add(e);

  dynamic toJson() {
    return events.map((event) => event.toJson()).toList();
  }

  void dump() {
    print('Raw Events:');
    for (int i = 0; i < events.length; i++) {
      print(events[i]);
    }
    print('Summary: ');
    var summary = new AssetPackTraceSummary(events);
    summary.dump();
  }

}