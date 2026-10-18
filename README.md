
# Phased Array Beamforming and Target Tracking Simulation

**MATLAB | Antenna Arrays | Electronic Beam Steering | Beamforming | Target Tracking**

## Overview

This project investigates the behavior and performance of phased-array antennas using MATLAB. The goal was to better understand how antenna arrays electronically steer their beams, how array geometry influences radiation patterns, and how practical limitations affect beam steering and target tracking.

The project began with analytical modeling of a **uniform linear array (ULA)** and expanded to include beamforming, radiation-pattern analysis, and a simplified moving-target tracking simulation.

The work focuses on concepts applicable to **radar systems, satellite communications, and wireless communications**.

## Project Objectives

- Model uniform linear antenna arrays using analytical array-factor equations.
- Implement electronic beam steering through progressive phase shifts.
- Analyze the influence of element spacing, array size, and steering angle.
- Calculate half-power beamwidth (HPBW), first-null beamwidth (FNBW), and sidelobe levels.
- Investigate grating-lobe formation.
- Explore moving-target tracking with system delay, measurement noise, and sidelobe-related interference.
- Evaluate tracking performance using normalized RMS angular error.

---

## 1. Array Factor and Beamforming

Phased-array antennas use multiple antenna elements to form a directional beam. By controlling the relative phase of the signal at each element, the main beam can be electronically steered without physically moving the array.

For a uniform linear array, the array factor is:

$$
AF(\theta)=\sum_{n=0}^{N-1}e^{jn(kd\sin\theta+\beta)}
$$

Where:

- $N$ = Number of antenna elements
- $d$ = Distance between adjacent elements
- $k=2\pi/\lambda$ = Wavenumber
- $\theta$ = Observation angle
- $\beta$ = Progressive phase shift

The phase progression required to steer the main beam toward $\theta_0$ is:

$$
\beta=-kd\sin(\theta_0)
$$

The MATLAB implementation calculates the complex array factor and plots the resulting response over an angular range of -90° to +90°.

### Beam Steering

Electronic beam steering is accomplished by changing the progressive phase shift applied between elements.

For example, an array with half-wavelength element spacing requires a progressive phase shift of **-90°** to steer its main beam toward **30°**.

The simulation demonstrates how changing the steering angle modifies the direction of constructive interference while maintaining the same physical antenna arrangement.

### Beamforming Method

The project implements **conventional phase-shift beamforming** with equal-amplitude array elements.

The model assumes ideal antenna elements and does not incorporate mutual coupling or individual element radiation patterns.

---

## 2. Radiation Pattern Analysis

The array-factor model was used to investigate how antenna geometry affects the resulting radiation pattern.

The following metrics were evaluated:

- **Half-Power Beamwidth (HPBW):** Angular width of the main beam between its -3 dB points.
- **First-Null Beamwidth (FNBW):** Angular separation between the first nulls surrounding the main beam.
- **Sidelobe Level (SLL):** Relative amplitude of the strongest sidelobe compared with the main beam.

### Representative Results

| Array Configuration | HPBW | FNBW | Observation |
|---|---:|---:|---|
| 16 elements, 0.5λ spacing, broadside | 6.67° | 14.36° | Narrow main beam |
| 16 elements, 0.5λ spacing, 30° steering | 7.57° | — | Electronically steered beam |
| 8 elements, 0.5λ spacing, broadside | 14.95° | 28.96° | Increased beamwidth |
| 16 elements, 1.0λ spacing, broadside | 3.96° | 7.17° | Narrower main beam with grating-lobe tradeoffs |

The reported sidelobe level for the 16-element, half-wavelength-spaced broadside array was approximately **-13.15 dB**, consistent with the expected behavior of a uniformly weighted array.

### Key Observations

- Increasing the number of elements at fixed spacing increases the array aperture and narrows the main beam.
- Progressive phase shifts allow electronic control of the beam direction.
- Steering away from broadside increases the angular width of the main beam.
- Larger element spacing can improve angular resolution but introduces grating-lobe risks.

---

## 3. Target Tracking Simulation

The project was extended to investigate how a phased-array receiver might track a moving target under nonideal conditions.

The simulated target follows a sinusoidal angular trajectory:

$$
\theta_{\text{target}}(t)=20\sin(2\pi\cdot0.5t)
$$

This produces a moving target between approximately **-20° and +20°**.

The MATLAB tracking model incorporates:

- **Measurement noise:** Gaussian noise added to angular measurements.
- **System lag:** A delay between the target measurement and beam-pointing update.
- **Sidelobe-related interference:** A simplified additional error term scaled by the sidelobe level.

The simulation compares the actual target direction with the delayed and noisy beam-pointing estimate.

### Tracking Performance

Angular tracking error is calculated as:

$$
e(t)=\theta_{\text{steered}}(t)-\theta_{\text{target}}(t)
$$

The error is normalized by the array half-power beamwidth:

$$
e_{\text{norm}}(t)=\frac{e(t)}{\text{HPBW}}
$$

Overall tracking performance is evaluated using root-mean-square error:

$$
e_{\text{RMS}}=
\sqrt{\frac{1}{M}\sum_{i=1}^{M}e_{\text{norm}}(i)^2}
$$

The baseline simulation documented in the project report produced a normalized RMS tracking error of approximately **0.3845**.

### Parameter Studies

Additional simulations investigate the effects of:

- Increasing or decreasing antenna beamwidth
- Varying measurement noise
- Changing system response delay
- Modifying antenna-element spacing

These studies illustrate the relationship between spatial resolution, tracking responsiveness, and measurement uncertainty.

**Note:** The tracking portion uses a simplified angular-measurement model rather than a complete direction-of-arrival estimator or adaptive beamforming receiver. Its results are exploratory and should not be interpreted as validated hardware performance.

---

## 4. MATLAB Implementation

The MATLAB scripts include:

- Analytical array-factor calculations
- Progressive phase-shift beam steering
- Radiation-pattern visualization
- Linear and decibel-scale plotting
- HPBW and FNBW calculations
- Sidelobe analysis
- Target-motion simulation
- Tracking-error calculations
- Parameter sweeps for noise, lag, beamwidth, and element spacing

The simulation uses analytical antenna-array equations rather than full-wave electromagnetic modeling.

---

## 5. Engineering Skills Demonstrated

| Skill | Application |
|---|---|
| MATLAB Programming | Numerical modeling, complex arithmetic, visualization, and parameter sweeps |
| Antenna Theory | Array factors, beamwidth, sidelobes, and grating lobes |
| Beamforming | Progressive phase shifting and electronic beam steering |
| Signal Analysis | Pattern normalization and decibel calculations |
| System Modeling | Measurement noise, latency, and tracking-error analysis |
| Engineering Analysis | Evaluating design tradeoffs and interpreting simulation results |

---

## 6. Limitations and Future Work

This project is currently a MATLAB-based analytical simulation. No physical phased-array antenna has been constructed or tested as part of this work.

Planned or potential improvements include:

1. **Beam Steering Visualization:** Create an animation showing how the main beam moves with changes in progressive phase shift.
2. **Amplitude Tapering:** Compare uniform excitation with tapered element weights to investigate sidelobe suppression.
3. **Improved Tracking Models:** Implement direction-of-arrival estimation and filtering techniques.
4. **Adaptive Beamforming:** Explore MVDR/Capon beamforming for interference rejection.
5. **Hardware Implementation:** Eventually design phase-shifting and gain-control circuitry for a physical antenna array.

---

## Tools and Technologies

- MATLAB
- Antenna Array Theory
- Electronic Beam Steering
- Conventional Beamforming
- Numerical Simulation
- Signal Processing
- Target Tracking Analysis

---

## Author

**Josiah Germain**  
Electrical Engineering — University of Houston

[GitHub Profile](https://github.com/jgermain)
