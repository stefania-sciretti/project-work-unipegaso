package com.clinica.repository

import com.clinica.domain.Patient
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface PatientRepository : JpaRepository<Patient, Long> {
    fun findByFiscalCode(fiscalCode: String): Optional<Patient>
    fun existsByFiscalCode(fiscalCode: String): Boolean
    fun findByLastNameContainingIgnoreCaseOrFirstNameContainingIgnoreCase(
        lastName: String, firstName: String
    ): List<Patient>
}
