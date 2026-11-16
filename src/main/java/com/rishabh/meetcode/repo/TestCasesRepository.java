package com.rishabh.meetcode.repo;

import com.rishabh.meetcode.model.TestCases;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestCasesRepository extends JpaRepository<TestCases, Long> {

    List<TestCases> findByProblem_id(Long id);

    @Modifying
    @Query("DELETE FROM TestCases tc WHERE tc.problem.id = :problemId")
    int deleteAllByProblemId(@Param("problemId") Long problemId);
}
