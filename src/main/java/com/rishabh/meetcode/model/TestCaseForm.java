package com.rishabh.meetcode.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TestCaseForm {

    private String input;

    private String expectedOutput;

    private boolean publicTestCase;
}
