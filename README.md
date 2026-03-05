# Design and Hardware Implementation of an 8-bit Linear Phase FIR Filter
* **Objective:** Designed and implemented an 8-bit linear phase FIR low-pass filter from specification to hardware-level Verilog implementation.

* **Architecture & Analysis:**
Implemented a Linear Phase structure to exploit coefficient symmetry, reducing the total number of required multipliers and adders to optimize area and power.
Performed finite wordlength analysis, verifying that Q7 fixed-point quantization of coefficients maintained filter stability and met stopband attenuation requirements (>20 dB).

* **Implementation & Tools:**
* **MATLAB/Simulink:** Verified functional correctness using mixed-frequency sine wave test cases.
* **Verilog:** Developed a structural model using signed carry-save multipliers and Carry Look Ahead (CLA) adders with overflow saturation logic.

* **Performance:** Achieved a maximum hardware operational frequency of ~71 MHz based on 0.18 µm CMOS delay models.
