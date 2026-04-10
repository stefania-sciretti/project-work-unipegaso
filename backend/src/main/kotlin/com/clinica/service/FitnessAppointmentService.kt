package com.clinica.service

import com.clinica.domain.AppointmentStatus
import com.clinica.domain.FitnessAppointment
import com.clinica.dto.FitnessAppointmentRequest
import com.clinica.dto.FitnessAppointmentResponse
import com.clinica.dto.FitnessAppointmentStatusRequest
import com.clinica.repository.ClientRepository
import com.clinica.repository.FitnessAppointmentRepository
import com.clinica.repository.TrainerRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class FitnessAppointmentService(
    private val appointmentRepository: FitnessAppointmentRepository,
    private val clientRepository: ClientRepository,
    private val trainerRepository: TrainerRepository
) {

    @Transactional(readOnly = true)
    fun findAll(clientId: Long?, trainerId: Long?, status: String?): List<FitnessAppointmentResponse> {
        val list = when {
            clientId != null -> appointmentRepository.findByClientId(clientId)
            trainerId != null -> appointmentRepository.findByTrainerId(trainerId)
            status != null -> appointmentRepository.findByStatus(AppointmentStatus.valueOf(status.uppercase()))
            else -> appointmentRepository.findAll()
        }
        return list.map { it.toResponse() }
    }

    @Transactional(readOnly = true)
    fun findById(id: Long): FitnessAppointmentResponse =
        appointmentRepository.findById(id)
            .orElseThrow { NoSuchElementException("Appointment not found with id: $id") }
            .toResponse()

    fun create(request: FitnessAppointmentRequest): FitnessAppointmentResponse {
        val client = clientRepository.findById(request.clientId)
            .orElseThrow { NoSuchElementException("Client not found with id: ${request.clientId}") }
        val trainer = trainerRepository.findById(request.trainerId)
            .orElseThrow { NoSuchElementException("Trainer not found with id: ${request.trainerId}") }

        val appt = FitnessAppointment(
            client = client,
            trainer = trainer,
            scheduledAt = request.scheduledAt,
            serviceType = request.serviceType,
            notes = request.notes
        )
        return appointmentRepository.save(appt).toResponse()
    }

    fun updateStatus(id: Long, request: FitnessAppointmentStatusRequest): FitnessAppointmentResponse {
        val appt = appointmentRepository.findById(id)
            .orElseThrow { NoSuchElementException("Appointment not found with id: $id") }
        val newStatus = try {
            AppointmentStatus.valueOf(request.status.uppercase())
        } catch (e: IllegalArgumentException) {
            throw IllegalArgumentException(
                "Invalid status '${request.status}'. Valid values: ${AppointmentStatus.entries.joinToString()}"
            )
        }
        appt.status = newStatus
        return appointmentRepository.save(appt).toResponse()
    }

    fun delete(id: Long) {
        val appt = appointmentRepository.findById(id)
            .orElseThrow { NoSuchElementException("Appointment not found with id: $id") }
        appt.status = AppointmentStatus.CANCELLED
        appointmentRepository.save(appt)
    }

    private fun FitnessAppointment.toResponse() = FitnessAppointmentResponse(
        id = id,
        clientId = client.id,
        clientFullName = "${client.firstName} ${client.lastName}",
        trainerId = trainer.id,
        trainerFullName = "${trainer.firstName} ${trainer.lastName}",
        trainerRole = trainer.role.name,
        scheduledAt = scheduledAt,
        serviceType = serviceType,
        status = status.name,
        notes = notes,
        createdAt = createdAt
    )
}
