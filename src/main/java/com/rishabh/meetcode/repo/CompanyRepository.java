
package com.rishabh.meetcode.repo;

import com.rishabh.meetcode.model.Company;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface CompanyRepository
        extends JpaRepository<Company, Long> {

    Optional<Company> findByNameIgnoreCase(String name);

    List<Company> findAllByOrderByNameAsc();

    @Query("""
    SELECT c.id, c.name, COUNT(p.id)
    FROM Problem p
    JOIN p.companies c
    WHERE p.active = true
      AND p.deleted = false
    GROUP BY c.id, c.name
    ORDER BY COUNT(p.id) DESC
    """)
    List<Object[]> findCompanyProblemCounts();
}


