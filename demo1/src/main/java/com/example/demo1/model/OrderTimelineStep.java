package com.example.demo1.model;

import java.sql.Timestamp;

public class OrderTimelineStep {
    private String status;
    private Timestamp occurredAt;
    private boolean completed;
    private boolean current;
    private boolean cancelled;

    public OrderTimelineStep() {
    }

    public OrderTimelineStep(String status, Timestamp occurredAt, boolean completed, boolean current, boolean cancelled) {
        this.status = status;
        this.occurredAt = occurredAt;
        this.completed = completed;
        this.current = current;
        this.cancelled = cancelled;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getOccurredAt() {
        return occurredAt;
    }

    public void setOccurredAt(Timestamp occurredAt) {
        this.occurredAt = occurredAt;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public boolean isCurrent() {
        return current;
    }

    public void setCurrent(boolean current) {
        this.current = current;
    }

    public boolean isCancelled() {
        return cancelled;
    }

    public void setCancelled(boolean cancelled) {
        this.cancelled = cancelled;
    }
}
