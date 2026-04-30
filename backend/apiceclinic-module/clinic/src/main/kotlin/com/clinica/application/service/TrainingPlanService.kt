package com.clinica.application.service

import com.clinica.application.domain.TrainingPlan
import com.clinica.doors.outbound.database.dao.PatientDao
import com.clinica.doors.outbound.database.dao.StaffDao
import com.clinica.doors.outbound.database.dao.TrainingPlanDao
import com.clinica.dto.TrainingPlanRequest
import com.clinica.dto.TrainingPlanResponse
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class TrainingPlanService(
    private val trainingPlanDao: TrainingPlanDao,
    private val patientDao: PatientDao,
    private val staffDao: StaffDao
) : TrainingPlanServicePort {

    @Transactional(readOnly = true)
    override fun findAll(clientId: Long?): List<TrainingPlanResponse> =
        trainingPlanDao.findAll(clientId).map { it.toResponse() }

    @Transactional(readOnly = true)
    override fun findById(id: Long): TrainingPlanResponse =
        trainingPlanDao.findById(id).orThrow("Training plan not found with id: $id").toResponse()

    override fun create(request: TrainingPlanRequest): TrainingPlanResponse {
        val client = patientDao.findById(request.clientId)
            .orThrow("Client not found with id: ${request.clientId}")
        val trainer = staffDao.findById(request.trainerId)
            .orThrow("Staff not found with id: ${request.trainerId}")

        val plan = TrainingPlan(
            client = client,
            trainer = trainer,
            title = request.title,
            description = request.description,
            weeks = request.weeks,
            sessionsPerWeek = request.sessionsPerWeek,
            active = request.active
        )
        return trainingPlanDao.save(plan).toResponse()
    }

    override fun update(id: Long, request: TrainingPlanRequest): TrainingPlanResponse {
        trainingPlanDao.findById(id).orThrow("Training plan not found with id: $id")

        val client = patientDao.findById(request.clientId)
            .orThrow("Client not found with id: ${request.clientId}")
        val trainer = staffDao.findById(request.trainerId)
            .orThrow("Staff not found with id: ${request.trainerId}")

        val updated = TrainingPlan(
            id = id,
            client = client,
            trainer = trainer,
            title = request.title,
            description = request.description,
            weeks = request.weeks,
            sessionsPerWeek = request.sessionsPerWeek,
            active = request.active
        )
        return trainingPlanDao.save(updated).toResponse()
    }

    override fun delete(id: Long) {
        trainingPlanDao.findById(id).orThrow("Training plan not found with id: $id")
        trainingPlanDao.deleteById(id)
    }

    private fun TrainingPlan.toResponse() = TrainingPlanResponse(
        id = id,
        clientId = client.id,
        clientFullName = client.fullName,
        trainerId = trainer.id,
        trainerFullName = trainer.fullName,
        title = title,
        description = description,
        weeks = weeks,
        sessionsPerWeek = sessionsPerWeek,
        active = active,
        createdAt = createdAt
    )
}
