/* (C)2026 */
package com.github.lamarios.podku.websockets;

import com.github.lamarios.podku.episodes.Episode;

public record PlayerStatus(
        WebsocketClient client,
        Episode episode,
        long position,
        long duration,
        boolean playing,
        double speed,
        double volume,
        boolean broadcast
) {}
