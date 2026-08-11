/* (C)2026 */
package com.github.lamarios.podku.websockets;

import com.github.lamarios.podku.episodes.Episode;

public record TransferPlayback(Episode episode, long position, String playerId) {}
