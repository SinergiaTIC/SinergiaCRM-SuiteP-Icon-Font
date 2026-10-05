export default {
  multipass: true,
  plugins: [
    {
      name: 'preset-default',
      params: {
        overrides: {
          convertTransform: false,
          convertPathData: false,
        },
      },
    },
  ],
};
