package com.github.lamarios.podku.websockets;


import java.util.Arrays;

public class WebSocketMessage<T> {
    public enum Type {
        playbackProgress(PlaybackProgress.class);


        private final Class<?> clazz;

        Type(Class<?> clazz) {
            this.clazz = clazz;
        }

        public static Type getFromClass(Class<?> clazz) {
            return Arrays.stream(Type.values()).filter(t -> t.clazz == clazz).findFirst().orElseThrow();
        }

        public Class<?> getClazz() {
            return clazz;
        }
    }

    private Type type;
    private T message;

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public T getMessage() {
        return message;
    }

    public void setMessage(T message) {
        this.message = message;
    }
}
