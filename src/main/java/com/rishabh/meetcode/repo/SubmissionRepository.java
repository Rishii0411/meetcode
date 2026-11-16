package com.rishabh.meetcode.repo;

import com.rishabh.meetcode.model.Submission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface SubmissionRepository extends JpaRepository<Submission, Long> {
    List<Submission> findByProblem_IdAndUser_IdOrderBySubmittedAtDesc(
            Long problemId,
            Long userId
    );

    @Query("""
    SELECT COUNT(DISTINCT s.problem.id)
    FROM Submission s
    WHERE s.user.id = :userId
    AND s.verdict = :verdict
    """)
    long countSolvedProblems(
            @Param("userId") Long userId,
            @Param("verdict") String verdict
    );

    @Query("""
    SELECT COUNT(DISTINCT s.problem.id)
    FROM Submission s
    WHERE s.user.id = :userId
    AND s.verdict = 'Accepted'
    AND s.problem.difficulty = :difficulty
""")
    long countSolvedByDifficulty(
            @Param("userId") Long userId,
            @Param("difficulty") String difficulty
    );

    long countByUser_Id(Long userId);

    long countByUser_IdAndVerdict(Long userId, String accepted);

    List<Submission> findByUser_IdOrderBySubmittedAtDesc(Long userId);


    Optional<Submission> findByIdAndProblem_IdAndUser_Id(
            Long submissionId,
            Long problemId,
            Long userId
    );

    boolean existsByProblem_Id(Long problemId);
    @Query("""
    SELECT COUNT(DISTINCT s.problem.id)
    FROM Submission s
    WHERE s.user.id = :userId
    AND s.verdict = 'Accepted'
""")
    long countBySolvedActiveTrue(
            @Param("userId") Long userId
    );

    @Query("""
    SELECT DISTINCT s.problem.id
    FROM Submission s
    WHERE s.user.id = :userId
    AND s.verdict = 'Accepted'
    """)
    List<Long> findAcceptedProblemIdsByUserId(
            @Param("userId") Long userId
    );

    @Query("""
    SELECT CASE WHEN COUNT(s) > 0 THEN true ELSE false END
    FROM Submission s
    WHERE s.user.id = :userId
    AND s.submittedAt >= :startOfDay
    AND s.submittedAt < :startOfNextDay
    """)
    boolean existsSubmissionBetween(
            @Param("userId") Long userId,
            @Param("startOfDay") LocalDateTime startOfDay,
            @Param("startOfNextDay") LocalDateTime startOfNextDay
    );

    @Query("""
    SELECT MIN(s.submittedAt)
    FROM Submission s
    WHERE s.user.id = :userId
    AND s.verdict = 'Accepted'
    GROUP BY s.problem.id
    ORDER BY MIN(s.submittedAt)
""")
    List<LocalDateTime> findAcceptedSubmissionTimestamps(
            @Param("userId") Long userId
    );
}
