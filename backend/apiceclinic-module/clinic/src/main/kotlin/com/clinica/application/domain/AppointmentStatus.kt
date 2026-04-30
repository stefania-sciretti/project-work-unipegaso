package com.clinica.application.domain

enum class AppointmentStatus {
    BOOKED,
    CONFIRMED,
    COMPLETED,
    CANCELLED;

    companion object {
        fun parse(value: String): AppointmentStatus =
            entries.find { it.name == value.uppercase() }
                ?: throw IllegalArgumentException("Invalid appointment status: '$value'")
    }
}
