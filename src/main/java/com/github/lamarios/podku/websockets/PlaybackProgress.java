/* (C)2026 */
package com.github.lamarios.podku.websockets;

public record PlaybackProgress(String episodeId, Double progress, String player, boolean newPlayback) {}
