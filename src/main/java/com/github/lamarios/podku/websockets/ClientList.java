/* (C)2026 */
package com.github.lamarios.podku.websockets;

import java.util.List;

public record ClientList(WebsocketClient currentPlayer, List<WebsocketClient> clients) {}
