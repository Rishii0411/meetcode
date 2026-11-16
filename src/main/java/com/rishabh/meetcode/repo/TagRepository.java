package com.rishabh.meetcode.repo;

import com.rishabh.meetcode.model.Tag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TagRepository extends JpaRepository<Tag,Integer> {
    Optional<Tag> findByName(String tagName);

    @Query("""
    SELECT t.name, COUNT(p.id)
    FROM Tag t
    JOIN t.problems p
    GROUP BY t.name
""")
    List<Object[]> findTagCounts();
}
