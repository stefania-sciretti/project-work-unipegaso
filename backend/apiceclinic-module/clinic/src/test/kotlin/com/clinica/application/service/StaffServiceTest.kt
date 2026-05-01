package com.clinica.application.service

import com.clinica.application.domain.Staff
import com.clinica.doors.outbound.database.dao.StaffDao
import io.mockk.every
import io.mockk.impl.annotations.InjectMockKs
import io.mockk.impl.annotations.MockK
import io.mockk.junit5.MockKExtension
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.junit.jupiter.api.extension.ExtendWith
import java.time.LocalDateTime

@ExtendWith(MockKExtension::class)
class StaffServiceTest {

    @MockK
    private lateinit var staffDao: StaffDao

    @InjectMockKs
    private lateinit var service: StaffService

    private fun buildStaff(id: Long = 1L, role: String = "NUTRITIONIST") = Staff(
        id = id, firstName = "Anna", lastName = "Verdi",
        role = role, bio = "Specialist", email = "anna@example.com",
        createdAt = LocalDateTime.now(), updatedAt = LocalDateTime.now()
    )

    // findAll

    @Test
    fun `findAll returns all staff members`() {
        every { staffDao.findAll() } returns listOf(buildStaff(1L), buildStaff(2L, "TRAINER"))

        val result = service.findAll()

        assertEquals(2, result.size)
        assertEquals("NUTRITIONIST", result[0].role)
        assertEquals("TRAINER", result[1].role)
    }

    @Test
    fun `findAll returns empty list when no staff`() {
        every { staffDao.findAll() } returns emptyList()
        assertEquals(0, service.findAll().size)
    }

    // findByRole

    @Test
    fun `findByRole returns staff matching role`() {
        every { staffDao.findByRole("TRAINER") } returns listOf(buildStaff(2L, "TRAINER"))

        val result = service.findByRole("TRAINER")

        assertEquals(1, result.size)
        assertEquals("TRAINER", result[0].role)
    }

    @Test
    fun `findByRole returns empty list when no match`() {
        every { staffDao.findByRole("UNKNOWN") } returns emptyList()
        assertEquals(0, service.findByRole("UNKNOWN").size)
    }

    // findById

    @Test
    fun `findById returns staff response`() {
        every { staffDao.findById(1L) } returns buildStaff()

        val result = service.findById(1L)

        assertEquals(1L, result.id)
        assertEquals("Anna", result.firstName)
        assertEquals("NUTRITIONIST", result.role)
    }

    @Test
    fun `findById throws NoSuchElementException when not found`() {
        every { staffDao.findById(99L) } returns null

        val ex = assertThrows<NoSuchElementException> { service.findById(99L) }
        assert(ex.message!!.contains("99"))
    }
}
