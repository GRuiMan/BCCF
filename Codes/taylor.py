#reset -f 
#clear
from matplotlib.projections import PolarAxes
from mpl_toolkits.axisartist import floating_axes
from mpl_toolkits.axisartist import grid_finder
import numpy as np
import matplotlib.pyplot as plt

class TaylorDiagram:
    def __init__(self, fig, refsample, r2_locs):
        self.fig = fig
        self.refsample = refsample
        self.r2_locs = r2_locs
        self.polar_ax = self.set_tayloraxes()  # Create axes once during initialization

    def set_tayloraxes(self):
        trans = PolarAxes.PolarTransform()
        r1_locs = np.hstack((np.arange(1,10)/10.0,[0.95,0.99]))
        t1_locs = np.arccos(r1_locs)
        gl1 = grid_finder.FixedLocator(t1_locs)
        tf1 = grid_finder.DictFormatter(dict(zip(t1_locs, map(str,r1_locs))))
        r2_labels = self.r2_locs
        gl2 = grid_finder.FixedLocator(self.r2_locs)
        tf2 = grid_finder.DictFormatter(dict(zip(self.r2_locs, map(str,r2_labels))))
        ghelper = floating_axes.GridHelperCurveLinear(trans,
                                                    extremes=(0,np.pi/2,min(self.r2_locs),max(self.r2_locs)),
                                                    grid_locator1=gl1,tick_formatter1=tf1,
                                                    grid_locator2=gl2,tick_formatter2=tf2)
        ax = floating_axes.FloatingSubplot(self.fig, 111, grid_helper=ghelper)
        self.fig.add_subplot(ax)

        labelsize = 25
        ax.axis["top"].set_axis_direction("bottom")
        ax.axis["top"].toggle(ticklabels=True, label=True)
        ax.axis["top"].major_ticklabels.set_axis_direction("top")
        ax.axis["top"].label.set_axis_direction("top")
        ax.axis["top"].label.set_text("Correlation")
        ax.axis["top"].label.set_fontsize(20)           # Increase label font size
        ax.axis["top"].major_ticklabels.set_fontsize(labelsize)  # Increase tick label font size

        ax.axis["left"].set_axis_direction("bottom")
        ax.axis["left"].label.set_text("Standard deviation")
        ax.axis["left"].label.set_fontsize(20)          # Increase label font size
        ax.axis["left"].major_ticklabels.set_fontsize(labelsize)  # Increase tick label font size

        ax.axis["right"].set_axis_direction("top")
        ax.axis["right"].toggle(ticklabels=True)
        ax.axis["right"].major_ticklabels.set_axis_direction("left")
        ax.axis["right"].major_ticklabels.set_fontsize(labelsize)  # Increase tick label font size

        ax.axis["bottom"].set_visible(False)
        ax.grid(True)
        polar_ax = ax.get_aux_axes(trans)

        return polar_ax

    def plot_taylor(self, sample, *args, **kwargs):
        std_ref = np.std(self.refsample)
        std_obs = np.std(sample)
        corr = np.corrcoef(self.refsample, sample)
        theta = np.arccos(np.abs(corr[0,1]))
        t_obs,r_obs = theta,std_obs

        d = self.polar_ax.plot(t_obs,r_obs, *args, **kwargs)  # Use the pre-created axes

        r2_locs = self.r2_locs

        # Draw the RMS contours only once
        if not hasattr(self, 'rms_drawn'):
            rs, ts = np.meshgrid(np.linspace(min(r2_locs), max(r2_locs), 100),
                                 np.linspace(0, np.pi/2, 100))
            rms = np.sqrt(std_ref**2 + rs**2 - 2*std_ref*rs*np.cos(ts))
            CS = self.polar_ax.contour(ts, rs, rms, colors='gray', linestyles='--')
            plt.clabel(CS, inline=1, fontsize=15)
            self.rms_drawn = True

        # Draw the std_ref=1.0 line only once
        if not hasattr(self, 'std_ref_line_drawn'):
            t = np.linspace(0, np.pi/2)
            r = np.zeros_like(t) + std_ref
            self.polar_ax.plot(t, r, 'k--')
            self.std_ref_line_drawn = True

        return std_obs, corr[0,1]
