package com.github.lamarios.podku.websockets;

import com.github.lamarios.podku.episodes.Episode;

public record PlayerStatus(WebsocketClient client, Episode episode, long position, long duration, boolean playing, double speed) {
}
