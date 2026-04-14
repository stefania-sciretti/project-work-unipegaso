package com.clinica.service

import com.clinica.domain.TrainingPlan
import com.clinica.dto.TrainingPlanRequest
import com.clinica.dto.TrainingPlanResponse
import com.clinica.repository.ClientRepository
import com.clinica.repository.StaffRepository
import com.clinica.repository.TrainingPlanRepository
import com.clinica.service.api.TrainingPlanServicePort
import com.clinica.util.orEntityNotFound
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class TrainingPlanService(
    private val trainingPlanRepository: TrainingPlanRepository,
    private val clientRepository: ClientRepository,
    private val staffRepository: StaffRepository
) : TrainingPlanServicePort {

    @Transactional(readOnly = true)
    override fun findAll(clientId: Long?): List<TrainingPlanResponse> {
        val plans = if (clientId != null) trainingPlanRepository.findByClientId(clientId)
                    else trainingPlanRepository.findAll()
        return plans.map { it.toResponse() }
    }

    @Transactional(readOnly = true)
    override fun findById(id: Long): TrainingPlanResponse =
        trainingPlanRepository.findById(id).orEntityNotFound("Training plan", id).toResponse()

    override fun create(request: TrainingPlanRequest): TrainingPlanResponse {
        val client = clientRepository.findById(request.clientId)
            .orEntityNotFound("Client", request.clientId)
        val staff = staffRepository.findById(request.trainerId)
            .orEntityNotFound("Staff", request.trainerId)

        val plan = TrainingPlan(
            client = client,
            staff = staff,
            title = request.title,
            description = request.description,
            weeks = request.weeks,
            sessionsPerWeek = request.sessionsPerWeek,
            active = request.active
        )
        return trainingPlanRepository.save(plan).toResponse()
    }

    override fun update(id: Long, request: TrainingPlanRequest): TrainingPlanResponse {
        val plan = trainingPlanRepository.findById(id).orEntityNotFound("Training plan", id)

        plan.title = request.title
        plan.description = request.description
        plan.weeks = request.weeks
        plan.sessionsPerWeek = request.sessionsPerWeek
        plan.active = request.active

        return trainingPlanRepository.save(plan).toResponse()
    }

    override fun delete(id: Long) {
        if (!trainingPlanRepository.existsById(id)) {
            throw NoSuchElementException("Training plan not found with id: $id")
        }
        trainingPlanRepository.deleteById(id)
    }

    private fun TrainingPlan.toResponse() = TrainingPlanResponse(
        id = id,
        clientId = client.id,
        clientFullName = "${client.firstName} ${client.lastName}",
        trainerId = staff.id,
        trainerFullName = "${staff.firstName} ${staff.lastName}",
        title = title,
        description = description,
        weeks = weeks,
        sessionsPerWeek = sessionsPerWeek,
        active = active,
        createdAt = createdAt
    )
}
