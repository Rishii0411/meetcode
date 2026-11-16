package com.rishabh.meetcode.dto;

import java.time.LocalDate;
import java.util.Set;

public record StreakSummary(
        int currentStreak,
        int longestStreak,
        Set<LocalDate> activeDates
) {
}
