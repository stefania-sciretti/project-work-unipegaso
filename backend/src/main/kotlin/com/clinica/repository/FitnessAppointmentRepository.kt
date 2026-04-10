package com.clinica.repository

import com.clinica.domain.AppointmentStatus
import com.clinica.domain.FitnessAppointment
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface FitnessAppointmentRepository : JpaRepository<FitnessAppointment, Long> {
    fun findByClientId(clientId: Long): List<FitnessAppointment>
    fun findByTrainerId(trainerId: Long): List<FitnessAppointment>
    fun findByStatus(status: AppointmentStatus): List<FitnessAppointment>
    fun countByStatus(status: AppointmentStatus): Long
}
