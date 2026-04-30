package com.clinica.application.service

import com.clinica.application.domain.Staff
import com.clinica.doors.outbound.database.dao.StaffDao
import com.clinica.dto.StaffResponse
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class StaffService(
    private val staffDao: StaffDao
) {

    @Transactional(readOnly = true)
    fun findAll(): List<StaffResponse> =
        staffDao.findAll().map { it.toResponse() }

    @Transactional(readOnly = true)
    fun findByRole(role: String): List<StaffResponse> =
        staffDao.findByRole(role).map { it.toResponse() }

    @Transactional(readOnly = true)
    fun findById(id: Long): StaffResponse =
        staffDao.findById(id).orThrow("Staff member $id not found").toResponse()

    private fun Staff.toResponse(): StaffResponse =
        StaffResponse(
            id = id,
            firstName = firstName,
            lastName = lastName,
            role = role,
            bio = bio,
            email = email,
            createdAt = createdAt
        )
}