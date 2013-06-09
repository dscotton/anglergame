/*
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>

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

part of simple_audio;

/** [AudioSound] is an [AudioClip] scheduled to be played on an [AudioSource].
 * You cannot construct an instance of the [AudioSound] class directly, it can only be
 * done by playing an [AudioClip] from an [AudioSource] (See [AudioSource], [AudioMusic], and [AudioManager]).
 */
class AudioSound {
  final AudioSource _source;
  final AudioClip _clip;
  final bool _loop;
  AudioBufferSourceNode _sourceNode;
  num _pausedTime;
  num _startTime;
  num _scheduledTime;
  num _volume = 1.0;

  /** Is the sound scheduled to be played? */
  bool get isScheduled => _sourceNode == null ? false : _sourceNode.playbackState == AudioBufferSourceNode.SCHEDULED_STATE;
  /** Is the sound playing right now? */
  bool get isPlaying => _sourceNode == null ? false : _sourceNode.playbackState == AudioBufferSourceNode.PLAYING_STATE;
  /** Is the sound finished being played? */
  bool get isFinished => _sourceNode == null ? false : _sourceNode.playbackState == AudioBufferSourceNode.FINISHED_STATE;

  AudioSound._internal(this._source, this._clip, this._loop) {
    _setupSourceNodeForPlayback();
  }

  void _dumpSourceNode() {
    if (_sourceNode != null) {
      print('${_sourceNode.playbackState}');
    }
  }

  void _setupSourceNodeForPlayback() {
    _sourceNode = _source._manager._context.createBufferSource();
    if (_clip != null && _clip._buffer != null) {
      _sourceNode.buffer = _clip._buffer;
      _sourceNode.loopStart = 0.0;
      _sourceNode.loopEnd = _clip._buffer.duration;
    }
    _sourceNode.gain.value = _volume;
    _sourceNode.loop = _loop;
    _sourceNode.connect(_source._gainNode, 0, 0);
  }

  void _stop() {
    if (_sourceNode != null) {
      _sourceNode.stop(0.0);
    }
    _sourceNode = null;
  }

  /** Is the sound paused? */
  bool get pause => _pausedTime != null;

  /** Pause or unpause the sound. */
  void set pause(bool b) {
    if (b) {
      if (_pausedTime != null) {
        // Double pause.
        return;
      }
      _pause();
    } else {
      if (_pausedTime == null) {
        // Double unpause.
        return;
      }
      _resume();
    }
  }

  /**
   * Time cursor for sound. Will be negative is sound is scheduled
   * to be played. Positive if playing.
   */
  num get time {
    var now = _source._manager._context.currentTime;
    if (_pausedTime != null) {
      return _pausedTime;
    }
    return _computePausedTime();
  }

  num _computePausedTime() {
    assert(_startTime != null);
    var now = _source._manager._context.currentTime;
    var delta = now - _startTime;
    if (now < _scheduledTime) {
      // Haven't started yet.
      return now-_scheduledTime;
    }
    // Playing sound.
    if (_loop) {
      return delta % _sourceNode.buffer.duration;
    }
    return delta;
  }

  void _pause() {
    if (_startTime == null) {
      // Not started.
      return;
    }
    print('Sound.pause');
    _dumpSourceNode();
    if (_sourceNode != null) {
      _pausedTime = _computePausedTime();
      _stop();
      print('paused at $_pausedTime');
    }
  }

  void _resume() {
    if (_pausedTime == null) {
      // Not paused.
      return;
    }
    print('Sound.resume');
    _dumpSourceNode();
    _setupSourceNodeForPlayback();
    if (_pausedTime < 0.0) {
      // Schedule again.
      _pausedTime = -_pausedTime;
      print('Scheduling to play sound in $_pausedTime.');
      _scheduledTime = _source._manager._context.currentTime+_pausedTime;
      _sourceNode.start(_scheduledTime, 0.0, _sourceNode.buffer.duration);
      _startTime = _source._manager._context.currentTime;
    } else {
      print('Starting to play at offset $_pausedTime');
      _scheduledTime = _source._manager._context.currentTime;
      _sourceNode.start(_scheduledTime, // Now.
                        _pausedTime, // Offset.
                        _sourceNode.buffer.duration-_pausedTime); // Length.
      // Offset the time that start was called by the offset into clip.
      _startTime = _source._manager._context.currentTime-_pausedTime;
    }
    // Clear paused time.
    _pausedTime = null;
  }

  /** Start playing this sound in [when] seconds. */
  void play([num when=0.0]) {
    //print('Sound.play');
    //_dumpSourceNode();
    _stop();
    _setupSourceNodeForPlayback();
    _scheduledTime = _source._manager._context.currentTime+when;
    _sourceNode.start(_scheduledTime);
    // Called start now.
    _startTime = _source._manager._context.currentTime;
  }

  /** Stop playing this sound */
  void stop() {
    _stop();
    _startTime = null;
    _scheduledTime = null;
    _pausedTime = null;
  }

  /** Get the volume of the sound. 0.0 <= volume <= 1.0. */
  num get volume => _volume;

  /** Set the volume for the sound. */
  void set volume(num v) {
    if (_sourceNode != null) {
      _sourceNode.gain.value = v;
    }
    _volume = v;
  }
}
