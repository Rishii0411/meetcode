package com.rishabh.meetcode.repo;

import com.rishabh.meetcode.model.Problem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface ProblemRepository
        extends JpaRepository<Problem, Long> {

    List<Problem> findByActiveTrueAndDeletedFalse();

    List<Problem> findByActiveFalseAndDeletedFalse();

    List<Problem> findByCompanies_IdAndActiveTrueAndDeletedFalse(Long companyId);

    int countByActiveTrue();
}
