/* (C)2026 */
package com.github.lamarios.podku.websockets;

import com.github.lamarios.podku.episodes.Episode;

public record RemoteCommand(CommandType type, Episode episode, Long position, Double speed, Double volume) {}
